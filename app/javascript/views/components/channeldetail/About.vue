<template>
  <div v-if="chat" class="bg-white flex flex-col p-4 overflow-auto">
    <span
      :class="!isProfile ? 'border-b-0 rounded-t-md' : 'rounded-md'"
      class="flex justify-between items-center border border-black-300 cursor-pointer hover:bg-transparent p-4 rounded-t-md"
    >
      <span>
        <p class="font-bold">{{ $t('chat_detail.topic') }}</p>
        <p v-if="selectedChat.topic">{{ selectedChat.topic }}</p>
        <p v-else class="cursor-pointer">{{ $t('chat_detail.add_topic') }}</p>
      </span>
      <span @click="toggleEditModal()">
        <p class="cursor-pointer text-info font-semibold p-2">
          {{ $t('actions.edit') }}
        </p>
      </span>
    </span>
    <span
      v-if="!isProfile && !isGroup"
      class="border border-black-300 cursor-pointer hover:bg-transparent p-4 border-b-1"
    >
      <p class="font-bold">{{ $t('chat_detail.description') }}</p>
      <p>{{ chat.description }}</p>
    </span>
    <span
      v-if="!isProfile"
      class="border border-black-300 cursor-pointer hover:bg-transparent p-4 border-t-0"
    >
      <p class="font-bold">{{ $t('chat_detail.created_by') }}</p>
      <p>
        {{ chat.creator_name }} on
        {{ formatDate(chat.created_at) }}
      </p>
    </span>
    <span
      v-if="!isProfile && !isGroup"
      class="border border-black-300 cursor-pointer hover:bg-transparent p-4 mb-4 border-t-0 rounded-b-md"
      @click="leaveChannel"
    >
      <p class="text-danger font-bold">{{ $t('chat_detail.leave') }}</p>
    </span>
    <span
      v-if="isProfile"
      class="border border-black-300 mt-2 hover:bg-transparent p-4 rounded-md"
    >
      <span class="flex gap-2 p-1 items-center">
        <i class="fa-regular fa-clock mx-1" />
        <p>{{ chat.local_time }} {{ $t('chat_detail.local_time') }}</p>
      </span>
      <span class="flex gap-2 p-1 items-center">
        <i class="fa-solid fa-phone mx-1" />
        <p class="text-info cursor-pointer hover:underline">
          {{ chat.contact_info.phone }}
        </p>
      </span>
      <span class="flex gap-2 p-1 items-center">
        <i class="fa-regular fa-envelope mx-1" />
        <p class="text-info cursor-pointer hover:underline">
          {{ chat.contact_info.email }}
        </p>
      </span>
      <p
        @click="showUserProfile(chat.id)"
        class="text-info font-semibold mx-2 mt-1 cursor-pointer hover:underline w-fit"
      >
        {{ $t('chat_detail.view_full_profile') }}
      </p>
    </span>
    <span
      v-if="isProfile && !isOwnProfile"
      class="flex gap-2 items-center border border-black-300 mt-2 hover:bg-transparent p-4 rounded-md"
    >
      <i class="fa-solid fa-user-plus mx-1" />
      <p class="text-info font-semibold cursor-pointer hover:underline w-fit">
        {{ $t('chat_detail.add_people_to_this_conversation') }}
      </p>
    </span>
    <span
      :class="isProfile && 'mt-2'"
      class="border border-black-300 cursor-pointer hover:bg-transparent p-4 rounded-md"
    >
      <p class="font-bold">{{ $t('chat_detail.files') }}</p>
      <p>{{ $t('chat_detail.file_content') }}</p>
    </span>
    <edit-topic-modal
      v-if="showModal"
      :closeModal="toggleEditModal"
      :chat="selectedChat"
    />
  </div>
</template>

<script>
import { useChannelStore } from '../../../stores/useChannelStore';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { storeToRefs } from 'pinia';
import moment from 'moment';
import { useMessageStore } from '../../../stores/useMessagesStore';
import EditTopicModal from './EditTopicModal.vue';

export default {
  props: {
    chat: Object,
    toggleModal: Function,
  },
  components: {
    EditTopicModal,
  },
  data() {
    return {
      showModal: false,
    };
  },
  computed: {
    isProfile() {
      return this.chat.conversation_type === 'Profile';
    },
    isOwnProfile() {
      return this.currentProfileStore.currentProfile.id === this.chat.id;
    },
    isGroup() {
      return this.chat.conversation_type === 'Group';
    },
    isChannel() {
      return this.chat.conversation_type === 'Channel';
    },
  },
  setup() {
    const channelStore = useChannelStore();
    const profilesStore = useProfileStore();
    const userProfileStore = useUserProfileStore();
    const currentProfileStore = useCurrentProfileStore();
    const rightPaneStore = useRightPaneStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return {
      channelStore,
      profilesStore,
      rightPaneStore,
      userProfileStore,
      currentProfileStore,
      selectedChat,
    };
  },
  methods: {
    async leaveChannel() {
      await this.channelStore.leaveChannel(this.chat.id);
      this.$router.push('/');
    },
    formatDate(date) {
      return moment(date).format('MMMM Do, YYYY');
    },
    showUserProfile(profile_id) {
      this.setUserProfileForPane(profile_id);
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    setUserProfileForPane(profile_id) {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === profile_id
      );
      this.userProfileStore.setUserProfile(profile);
      this.toggleModal();
    },
    toggleEditModal() {
      this.showModal = !this.showModal;
    },
  },
};
</script>
