<template>
  <div>
    <!-- Modal -->
    <div
      class="fixed top-0 right-0 bottom-0 left-0 flex justify-center items-center z-10"
      v-if="showModal"
    >
      <div
        class="relative bg-white rounded-lg overflow-hidden shadow-2xl w-2/3 sm:w-1/2 lg:w-1/3 xl:w-1/4 max-h-screen"
      >
        <!-- Header -->
        <div class="flex items-center justify-between py-4 px-6 bg-gray-100">
          <div class="text-xl font-medium text-gray-800">
            {{ $t(`members.add_members_modal_title`) }}
          </div>
          <button
            class="text-gray-400 hover:text-gray-500 focus:outline-none"
            @click="closeModal()"
          >
            <i class="fas fa-times"></i>
          </button>
        </div>

        <!-- Body -->
        <div class="m-3 !bg-danger">
          <n-select
            vertical
            v-model:value="selectedValues"
            multiple
            filterable
            placeholder="ex. Nathalie, or james@acme.com"
            :options="options"
            :loading="loading"
            clearable
            remote
            :clear-filter-after-select="true"
            :show-arrow="false"
            @search="handleSearch"
            size="large"
            @change="resetSelectedTag()"
          />
        </div>

        <!-- Footer -->
        <div class="flex items-center justify-end py-4 px-6 bg-gray-100">
          <button class="btn btn-blue-400 btn-lg" @click="submit()">Add</button>
        </div>
      </div>
    </div>
    <!-- Trigger -->
    <button class="btn btn-blue-400" @click="showModal = true">
      <i class="fas fa-user-plus fa-lg" />
    </button>
  </div>
</template>

<script>
import { NSelect } from 'naive-ui';
import { defineComponent, ref } from 'vue';
import {
  getMembers,
  addMemberstoChannel,
} from '../../../api/members/membersApi';

let options = [];

export default defineComponent({
  components: {
    NSelect,
  },
  data() {
    return {
      showModal: false,
    };
  },
  methods: {
    async submit() {
      let channel_id = window.location.pathname.split('/')[2];
      try {
        let Success_msg = await addMemberstoChannel(
          channel_id,
          this.selectedValues
        );
        alert(`${Success_msg.data.members[0]} added`);
      } catch (e) {
        console.error(e);
      }
      this.closeModal();
    },
    closeModal() {
      this.selectedValues = [];
      this.showModal = false;
    },
    resetSelectedTag() {
      this.value = '';
    },
  },
  setup() {
    const loadingRef = ref(false);
    const optionsRef = ref([]);
    return {
      selectedValues: ref(null),
      loading: loadingRef,
      options: optionsRef,
      handleSearch: query => {
        if (!query.length) {
          optionsRef.username = [];
          return;
        }
        loadingRef.value = true;
        window.setTimeout(async () => {
          options = await getMembers(1, query);
          optionsRef.value = options.map(item => {
            return {
              label: item.username,
              value: item.id,
            };
          });
          loadingRef.value = false;
        }, 1e3);
      },
    };
  },
});
</script>
<style scoped>
.fa-user-plus {
  color: black;
}
</style>
