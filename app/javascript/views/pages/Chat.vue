<template>
  <div v-if="conversation_type && id" class="flex flex-col h-full">
      <div v-if="chat" class="chat-header-style">
        <ChatHeader />
      </div>
      <div v-if="messages" class="break-words chat-style overflow-y-auto">
        <ChatBody @load-more-messages="loadMoreMessages" />
      </div>
      <div class="px-3 editor-style">
        <TextEditorVue :sendMessage="sendMessage" />
      </div>
  </div>
</template>

<script>
import ChatHeader from '../components/chats/ChatHeader.vue';
import { NInput, NSpace } from 'naive-ui';
import ChatBody from '../components/chats/ChatBody.vue';
import TextEditorVue from '../components/editor/TextEditor.vue';
import { createCable, unsubscribe } from '@/plugins/cable';
import { conversation } from '../../modules/axios/editorapi';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useCurrentUserStore } from '../../stores/useCurrentUserStore';
import { cableActions } from '../../modules/cable';
import { storeToRefs } from 'pinia';
export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    NInput,
    NSpace,
    TextEditorVue,
  },
  data() {
    return {
      chat: {},
      Cable: null,
    };
  },
  setup() {
    function getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    }
    const messageStore = useMessageStore();
    const currentUserStore = useCurrentUserStore();
    const conversation_type = getIndexByParams(1);
    const id = getIndexByParams(2);
    // messageStore.index(conversation_type, id);
    const { messages, currMessage, currentPage, hasMoreMessages } = storeToRefs(messageStore);
    const { currentUser } = storeToRefs(currentUserStore);
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
      conversation_type,
      currentUser,
      id,
    };
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
    this.messages = []
    this.currMessage = []
    this.currentPage = 1;
    unsubscribe();
    this.Cable = null;
  },
  methods: {
    sendMessage(message, files) {
      let formData = new FormData();
      formData.append('content', message);
      formData.append('is_threaded', false);
      formData.append('conversation_type', this.conversation_type);
      formData.append('conversation_id', this.id);
      files.forEach(file => {
        formData.append('message_attachments[]', file);
      });
      try {
        conversation(formData).then(() => {
          this.message = '';
        });
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>

<style scoped>
/* .editor {
  bottom: 0;
  float: left;
  width: 100%;
} */

.editor-style {
  flex : 0.3;
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
