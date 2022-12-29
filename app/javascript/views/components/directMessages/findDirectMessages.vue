<template>
  <div class="bg-secondary text-white border border-slate-600 h-screen -mb-12">
    <div class="grid text-slate-600 grid-cols-1 divide-y">
      <div class="p-2 text-white text-xl">
        {{ $t('direct_messages.direct_messages') }}
      </div>
      <div>
        <div class="flex p-3">
          <p>{{ $t('request.to') }}:</p>
          <input
            type="text"
            :placeholder="$t('find_direct_messages.somebody')"
            ouline="none"
            class="bg-secondary w-full ml-1"
            v-model="query"
            @keyup.enter="searchQuery()"
          />
        </div>
        <hr />
        <div class="w-full p-5">
          <div v-for="member in members" :key="member.id">
            <memberCardDm
              class="cursor-pointer"
              :name="member.username"
              :description="member.description"
              :img-url="member.image_url"
              @click="handleSelect(member)"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import memberCardDm from './memberCardDm.vue';
import { getMembers } from '../../../api/members/membersApi';
import { useDirectMessagesStore } from '../../../stores/userDirectMessagesStore';
export default {
  mounted() {
    this.searchQuery();
  },
  components: {
    memberCardDm,
  },
  data() {
    return {
      query: '',
      members: [],
      CurrentWorkspaceId: 1,
      users: [],
    };
  },
  beforeUnmount() {
    this.query = this.members = this.users = null;
  },
  setup() {
    const selectedDm = useDirectMessagesStore();
    return { selectedDm };
  },
  methods: {
    goToChat(chatURL) {
      this.$router.push(chatURL);
    },
    handleSelect(member) {
      this.selectedDm.appendToDirectMessagesList(member);
      this.selectedDm.setSelectedDm(member);
      this.goToChat(`/profiles/${member.id}`);
    },
    async searchQuery() {
      try {
        this.members = await getMembers(
          this.CurrentWorkspaceId,
          this.query,
          this.sort
        );
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>

<style scoped>
textarea:focus,
input:focus {
  outline: none;
}
</style>
