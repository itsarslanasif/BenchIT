<template>
  <div class="flex flex-col gap-2">
    <div v-if="conversation_type && id" class="h-full">
      <div v-if="chat">
        <ChatHeader />
      </div>
      <div v-if="messages" class="break-words h-1/2">
        <ChatBody />
      </div>
      <div class="px-3">
        <TextEditorVue :sendMessage="sendMessage" />
      </div>
    </div>
  </div>
</template>

<script>
import ChatHeader from '../components/chats/ChatHeader.vue';
import { NInput, NSpace } from 'naive-ui';
import ChatBody from '../components/chats/ChatBody.vue';
import TextEditorVue from '../components/editor/TextEditor.vue';
import { createCable } from '@/plugins/cable';
import { conversation } from '../../modules/axios/editorapi';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useCurrentUserStore } from '../../stores/useCurrentUserStore';
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
      messages: [],
      Cable: null,
      conversation_type: null,
      id: null,
      currentUser: {},
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
    const { messages } = storeToRefs(messageStore);
    const { currentUser } = storeToRefs(currentUserStore);
    messageStore.index(conversation_type, id);
    return {
      messages,
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
  },
  beforeUnmount() {
    this.chat = null;
    this.Cable = null;
  },

  updated() {
    this.Cable.on('chat', data => {
      let content = data.message.content
      if (data.message.type === 'Message'){
      const findMessage = this.messages.find(m => m.id === content.id);

      if (findMessage == undefined) {
        this.messages.push(content);
        this.message = '';
      }
    }
    });
  },

  methods: {
    sendMessage(message, files) {
      let formData = new FormData();
      formData.append('content', message);
      formData.append('is_threaded', false);
      formData.append('parent_message_id', null);
      formData.append('conversation_type', this.conversation_type);
      formData.append('conversation_id', this.id);
      files.forEach(file => {
        formData.append('message_attachments[]', file);
      });
      try {
        conversation(formData);
      } catch (e) {
        console.error(e);
      }
    },
  },
}
</script>

<style>
.editor {
  bottom: 0;
  float: left;
  width: 100%;
}

.mce-i-codesample {
  color: transparent !important;
  background-image: url(../../assets/images/codeblock.png) !important;
}
</style>
