<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="py-5">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text"
        v-model="query"
        :placeholder="$t('channel_details.find_members')"
        @keyup="searchQuery()"
      />
    </div>
    <div
      v-if="conversationInfoStore.conversationMembers.length > 0"
      class="maxHeight overflow-auto"
    >
      <div v-for="member in conversationInfoStore.conversationMembers" :key="member.id">
        <MemberCard
          class="cursor-pointer"
          :name="member.username"
          :email="member.contact_info.email"
          :imgUrl="member.image_url"
        />
      </div>
    </div>
    <p v-if="conversationInfoStore.conversationMembers.length == 0">
      {{ $t('channel_details.no_matches_found') }} " {{ query }} "
    </p>
  </div>
</template>

<script>
import MemberCard from '../../widgets/memberCard.vue';
import { useConversationInfoStore } from '../../../stores/useConversationInfoStore';
import { ref } from 'vue';
export default {
  name: 'About',
  components: { MemberCard },
  mounted() {
    this.searchQuery();
  },
  setup() {
    const conversationInfoStore = useConversationInfoStore();
    const query = ref('')
    return { conversationInfoStore, query };
  },
  methods: {
    async searchQuery() {
      try {
        await this.conversationInfoStore.getConversationMembers(this.query);
      } catch (e) {
        console.error(e)
      }
    },
  },
};
</script>
<style scoped>
.maxHeight {
  max-height: 400px;
}
</style>
