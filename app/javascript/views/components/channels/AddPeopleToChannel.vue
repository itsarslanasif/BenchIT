<template>
  <div v-if="response?.data">
    <benchit-alert
      :errorMessage="$t('members.error_message')"
      :successMessage="successMessage"
      :success="isSuccessfullResponse"
    />
  </div>
  <div>
    <div
      @click.self="closeModal()"
      class="fixed top-0 right-0 bottom-0 left-0 flex justify-center items-center z-10"
      v-if="showModal"
    >
      <div
        class="relative bg-white rounded overflow-hidden border border-black-400 shadow-md w-100"
      >
        <div class="flex items-center justify-between py-4 px-6">
          <div class="text-xl font-medium text-gray-800">
            {{ $t(`members.add_members_modal_title`) }} {{ channelName }}
          </div>
          <button
            class="text-gray-400 hover:text-gray-500 focus:outline-none"
            @click="closeModal()"
          >
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="m-3">
          <n-select
            vertical
            v-model:value="selectedValues"
            multiple
            filterable
            :placeholder="$t('placeholder.add_people_to_channel')"
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
        <div class="flex items-center justify-end py-4 px-6">
          <button
            class="border px-4 py-1 rounded hover:bg-transparent focus:outline-none"
            @click="submit()"
          >
            {{ $t('actions.add') }}
          </button>
        </div>
      </div>
    </div>
    <button
      class="btn btn-blue-400 focus:outline-none"
      :class="
        buttonText &&
        'text-info cursor-pointer mt-4 py-1 px-2 rounded bg-slate-50'
      "
      @click="showModal = true"
    >
      <font-awesome-icon
        icon="fa-user-plus"
        class="fa-lg align-baseline mr-1"
      />
      {{ buttonText }}
    </button>
  </div>
</template>

<script>
import { NSelect } from 'naive-ui';
import { storeToRefs } from 'pinia';
import { defineComponent } from 'vue';
import {
  getMembers,
  addMemberstoChannel,
} from '../../../api/members/membersApi';
import { CONSTANTS } from '../../../assets/constants';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import benchitAlert from '../../widgets/benchitAlert.vue';

export default defineComponent({
  components: {
    NSelect,
    benchitAlert,
  },
  props: {
    channelName: {
      type: String,
      default: undefined,
    },
    buttonText: {
      type: String,
      default: undefined,
    },
  },
  setup() {
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    return {
      currentWorkspace,
    };
  },
  data() {
    return {
      showModal: false,
      response: null,
      loading: false,
      options: [],
      selectedValues: null,
    };
  },
  beforeUnmount() {
    this.response = this.options = null;
  },
  computed: {
    isSuccessfullResponse() {
      return this.response.data.status === 'ok';
    },
    successMessage() {
      let status = this.response?.data.status;
      if (status && status == 'ok') {
        return `${this.response.data.member_count} ${CONSTANTS.MEMBER_SUCCESS_MESSAGE}`;
      } else {
        return CONSTANTS.SOMETHING_WENT_WRONG;
      }
    },
  },
  methods: {
    async submit() {
      let channel_id = window.location.pathname.split('/')[2];
      try {
        let response = await addMemberstoChannel(
          channel_id,
          this.selectedValues
        );
        this.response = response;
        this.closeModal();
      } catch (e) {
        console.error(e);
      }
    },
    handleSearch(query) {
      if (!query.length) {
        this.options.username = [];
        return;
      }
      this.loading = true;
      setTimeout(async () => {
        let options = await getMembers(this.currentWorkspace?.id, query);
        this.options = options.map(item => {
          return {
            label: item.username,
            value: item.id,
          };
        });
        this.loading = false;
      }, 1e3);
    },
    closeModal() {
      this.selectedValues = [];
      this.showModal = false;
    },
    resetSelectedTag() {
      this.value = '';
    },
  },
});
</script>
