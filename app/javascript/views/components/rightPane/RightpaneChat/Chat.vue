<template>
  <div
    class="flex flex-col h-full m-3 border border-black-500 rounded shadow-inner"
  >
    <div v-if="chat" class="chat-header-style">
      <ChatHeader :pinnedConversationStore="pinnedConversationStore" />
    </div>
    <div v-if="messages" class="break-words chat-style overflow-y-auto">
      <ChatBody
        @load-more-messages="loadMoreMessages"
        :oldestUnreadMessageId="oldestUnreadMessageId"
        :messageStore="messageStore"
        :threadStore="threadStore"
        :toggleThreadShow="rightPaneStore.toggleRightPaneThreadShow"
        :toggleUserProfileShow="rightPaneStore.toggleRightPaneUserProfileShow"
        :userProfileStore="userProfileStore"
        :pinnedConversationStore="pinnedConversationStore"
      />
    </div>
    <div class="px-3 editor-style" v-if="isMember">
      <TextEditorVue
        :sendMessage="sendMessage"
        :editMessage="false"
        :selectedChat="selectedChat"
      />
    </div>
    <div v-else>
      <JoinChannel :joinedTheChannel="joinedTheChannel" />
    </div>
  </div>
</template>

<script>
import ChatHeader from './ChatHeader.vue';
import JoinChannel from '../../../widgets/JoinChannel.vue';
import { NInput, NSpace } from 'naive-ui';
import ChatBody from '../../chats/ChatBody.vue';
import TextEditorVue from '../../editor/TextEditor.vue';
import { createCable, unsubscribe } from '@/plugins/cable';
import { conversation } from '../../../../modules/axios/editorapi';
import { useRightpaneMessageStore } from '../../../../stores/useRightpaneMessageStore';
import { useCurrentUserStore } from '../../../../stores/useCurrentUserStore';
import { cableActions } from '../../../../modules/cable/rightPaneIndex';
import { storeToRefs } from 'pinia';
import { useUnreadStore } from '../../../../stores/useUnreadStore';
import { useChannelDetailStore } from '../../../../stores/useChannelDetailStore';
import { useCurrentProfileStore } from '../../../../stores/useCurrentProfileStore';
import { useRightPaneThreadStore } from '../../../../stores/useRightPaneThreadStore';
import { useRightPaneStore } from '../../../../stores/useRightPaneStore';
import { useRightPaneUserProfileStore } from '../../../../stores/useRightPaneProfileStore';
import { useRightPanePinnedConversation } from '../../../../stores/useRightPanePinnedConversationStore';

export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    NInput,
    NSpace,
    TextEditorVue,
    JoinChannel,
  },
  data() {
    return {
      chat: {},
      Cable: null,
      conversation_type: null,
      id: null,
      currentUser: {},
      isMember: true,
      oldestUnreadMessageId: null,
    };
  },
  setup() {
    const messageStore = useRightpaneMessageStore();
    const currentUserStore = useCurrentUserStore();
    const unreadStore = useUnreadStore();
    const channelDetailStore = useChannelDetailStore();
    const currentProfileStore = useCurrentProfileStore();
    const threadStore = useRightPaneThreadStore();
    const rightPaneStore = useRightPaneStore();
    const userProfileStore = useRightPaneUserProfileStore();
    const pinnedConversationStore = useRightPanePinnedConversation();
    const {
      messages,
      currMessage,
      currentPage,
      hasMoreMessages,
      newMessageSent,
      selectedChat,
    } = storeToRefs(messageStore);
    const { currentUser } = storeToRefs(currentUserStore);
    const { channelMembers } = storeToRefs(channelDetailStore);
    const currentProfile = currentProfileStore.getCurrentProfile;
    return {
      messages,
      currMessage,
      currentPage,
      hasMoreMessages,
      messageStore,
      currentUser,
      newMessageSent,
      channelMembers,
      currentProfile,
      selectedChat,
      unreadStore,
      threadStore,
      rightPaneStore,
      userProfileStore,
      pinnedConversationStore,
    };
  },
  watch: {
    channelMembers() {
      this.isMember = this.channelMembers.some(
        profile => profile.id === this.currentProfile.id
      );
    },
  },
  mounted() {
    this.conversation_type =
      this.selectedChat.is_private !== undefined ? 'channels' : 'profiles';
    this.oldestUnreadMessageId = this.unreadStore.getOldestMessageId(
      this.conversation_type,
      this.selectedChat.id
    );
    this.unreadStore.markedChatAsRead(
      this.conversation_type,
      this.selectedChat.id
    );
    this.Cable = createCable({
      channel: 'ChatChannel',
      id: this.selectedChat.id,
      type: this.conversation_type,
      current_user_id: this.currentUser.id,
    });
    this.Cable.on('chat', data => {
      cableActions(data.message);
    });
  },
  beforeUnmount() {
    this.chat = null;
    this.messages = [];
    this.currMessage = [];
    this.currentPage = 1;
    unsubscribe();
    this.Cable = null;
  },
  methods: {
    sendMessage(message, files, schedule) {
      let formData = new FormData();
      formData.append('content', message);
      formData.append('is_threaded', false);
      formData.append('conversation_type', this.conversation_type);
      formData.append('conversation_id', this.selectedChat.id);
      if (schedule.value) {
        formData.append('scheduled_at', schedule.value);
      }
      files.forEach(file => {
        formData.append('message_attachments[]', file);
      });
      conversation(formData).then(res => {
        if (res.scheduled_at) {
          this.messageStore.addScheduleMessage(res);
        }
        this.message = '';
      });
      this.newMessageSent = true;
    },
    joinedTheChannel() {
      this.isMember = !this.isMember;
    },
    getConversationType() {
      return this.conversation_type === 'channels' ? 'BenchChannel' : 'Profile';
    },
    loadMoreMessages() {
      if (this.hasMoreMessages) {
        this.messageStore.index(this.conversation_type, this.selectedChat.id);
      }
    },
  },
};
</script>

<style scoped>
.editor-style {
  flex: 0.3;
}

.chat-header-style {
  flex: 0.1;
}

.chat-style {
  flex: 1;
}

.mce-i-codesample {
  color: transparent !important;
  background-image: url(../../assets/images/codeblock.png) !important;
}
</style>
