<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="py-5">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text"
        :placeholder="$t('channel_details.find_members')"
      />
    </div>
    <div
      v-if="messageStore.selectedChat.profiles.length > 0"
      class="maxHeight overflow-auto"
    >
      <div
        class="flex place-items-center ml-1 border border-transparent rounded-md px-4 py-2 mb-1 shadow-sm cursor-pointer hover:bg-transparent hover:font-bold"
        @click="toggleModal"
      >
        <font-awesome-icon class="w-8 h-8" icon="fa-solid fa-user-plus" />
        <span class="ml-3">{{ $t('groups.add_people') }}</span>
      </div>
      <div
        v-for="member in messageStore.selectedChat.profiles"
        :key="member.id"
      >
        <MermberCard
          class="cursor-pointer"
          :name="member.username"
          :description="member.description"
          :image_url="member.image_url"
        />
      </div>
    </div>
    <p v-if="messageStore.selectedChat.profiles.length == 0">
      {{ $t('channel_details.no_matches_found') }} " {{ query }} "
    </p>
    <CreateGroupModal
      v-if="showCreateGroupModal"
      title="Add people"
      :createNewGroup="false"
      :closeModal="toggleModal"
      :groupId="messageStore.selectedChat.id"
      @click.stop="stopPropagation"
    />
  </div>
</template>

<script>
import MermberCard from '../../widgets/memberCard.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore.js';
import { useMessageStore } from '../../../stores/useMessagesStore';
import CreateGroupModal from './createGroupModal.vue';
export default {
  name: 'About',
  components: { MermberCard, CreateGroupModal },
  query: '',
  data() {
    return {
      showCreateGroupModal: false,
    };
  },
  setup() {
    const channelDetailStore = useChannelDetailStore();
    const messageStore = useMessageStore();
    return { channelDetailStore, messageStore };
  },
  methods: {
    toggleModal() {
      this.showCreateGroupModal = !this.showCreateGroupModal;
    },
    async searchQuery() {
      let channel_id = window.location.pathname.split('/')[2];
      try {
        await this.channelDetailStore.getChannelMembers(this.query, channel_id);
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>
<style scoped>
.maxHeight {
  max-height: 300px;
}
</style>
