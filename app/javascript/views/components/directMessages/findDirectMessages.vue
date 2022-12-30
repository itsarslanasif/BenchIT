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
            <memberCard
              class="cursor-pointer"
              :name="member.username"
              :description="member.description"
              :img-url="member.image_url"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import memberCard from './memberCard.vue';
import { getMembers } from '../../../api/members/membersApi';
export default {
  mounted() {
    this.searchQuery();
  },
  components: {
    memberCard,
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
