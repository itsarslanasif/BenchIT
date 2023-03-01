<template>
  <div v-if="conversation_type && id" class="flex flex-col h-full">
    <div v-if="chat" class="chat-header-style">
      <ChatHeader />
    </div>
    <div v-if="messages" class="break-words chat-style overflow-y-auto">
      <ChatBody
        @load-more-messages="loadMoreMessages"
        :oldestUnreadMessageId="oldestUnreadMessageId"
      />
    </div>
    <div class="px-3 editor-style" v-if="isMember">
      <TextEditorVue
        :sendMessage="sendMessage"
        :editMessage="false"
        :isThread="false"
      />
    </div>
    <div v-else>
      <JoinChannel :joinedTheChannel="joinedTheChannel" />
    </div>
  </div>
</template>

<script>
import ChatHeader from '../components/chats/ChatHeader.vue';
import JoinChannel from '../widgets/JoinChannel.vue';
import { NInput, NSpace } from 'naive-ui';
import ChatBody from '../components/chats/ChatBody.vue';
import TextEditorVue from '../components/editor/TextEditor.vue';
import { createCable, unsubscribe } from '@/plugins/cable';
import { conversation } from '../../modules/axios/editorapi';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useCurrentUserStore } from '../../stores/useCurrentUserStore';
import { cableActions } from '../../modules/cable';
import { storeToRefs } from 'pinia';
import { useUnreadStore } from '../../stores/useUnreadStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';

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
    };
  },
  setup() {
    function getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    }
    const messageStore = useMessageStore();
    const currentUserStore = useCurrentUserStore();
    const unreadStore = useUnreadStore();
    const channelDetailStore = useChannelDetailStore();
    const currentProfileStore = useCurrentProfileStore();
    const conversation_type = getIndexByParams(1);
    const id = getIndexByParams(2);
    const {
      messages,
      currMessage,
      currentPage,
      hasMoreMessages,
      newMessageSent,
    } = storeToRefs(messageStore);
    const { currentUser } = storeToRefs(currentUserStore);
    const { channelMembers } = storeToRefs(channelDetailStore);
    const currentProfile = currentProfileStore.getCurrentProfile;
    const oldestUnreadMessageId = unreadStore.getOldestMessageId(
      conversation_type,
      id
    );
    unreadStore.markedChatAsRead(conversation_type, id);
    return {
      messages,
      currMessage,
      currentPage,
      hasMoreMessages,
      loadMoreMessages() {
        if (hasMoreMessages) {
          messageStore.index(conversation_type, id);
        }
      },
      messageStore,
      conversation_type,
      currentUser,
      oldestUnreadMessageId,
      newMessageSent,
      id,
      channelMembers,
      currentProfile,
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
    this.Cable = createCable({
      channel: 'ChatChannel',
      id: this.id,
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
    getFileFromBlob(blob, fileName) {
      const file = new File([blob], fileName, { type: blob.type });
      return file;
    },
    sendMessage(message, files, schedule) {
      if (message.blocks[0] != undefined) {
        let formData = new FormData();
        formData.append('content', JSON.stringify(message));
        formData.append('is_threaded', false);
        formData.append('conversation_type', this.conversation_type);
        formData.append('conversation_id', this.id);
        if (schedule) {
          formData.append('scheduled_at', schedule);
        }
        files.forEach(file => {
          const fileExtension = file.type.split('/')[1];
          const ts = new Date().getTime();
          let filename = ts;
          if (fileExtension == 'webm;codecs=opus') {
            filename += '.wav';
            file = this.getFileFromBlob(file, filename);
          } else if (
            fileExtension == 'x-matroska;codecs=avc1,opus' ||
            fileExtension == 'x-matroska;codecs=avc1'
          ) {
            filename += '.mp4';
            file = this.getFileFromBlob(file, filename);
          } else if (fileExtension == 'plain') {
            filename += '.txt';
            file = this.getFileFromBlob(file, filename);
          } else {
            filename += `.${fileExtension}`;
          }
          formData.append('message_attachments[]', file, filename);
        });
        conversation(formData).then(res => {
          if (res.scheduled_at) {
            this.messageStore.addScheduleMessage(res);
          }
          this.message = '';
        });
        this.newMessageSent = true;
      } else {
        return false;
      }
    },
    joinedTheChannel() {
      this.isMember = !this.isMember;
    },
    getConversationType() {
      return this.conversation_type === 'channels' ? 'BenchChannel' : 'Profile';
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
