<template>
  <thread-header :threadName="threadStore.message.receiver_name || threadStore.message.channel_name"
    :messageId="threadStore.message.id" />
  <div class="overflow-auto chatBody">
    <div class="pt-8">
      <MessageWrapper :curr-message="threadStore.message" />
    </div>
    <n-divider v-if="threadStore.message.replies" title-placement="left" class="text-black-500 text-xs">
      <p>{{ repliesCount }}</p>
    </n-divider>
    <template v-if="threadStore.message.replies">
      <template v-for="reply in threadStore.message.replies" :key="reply.id">
        <MessageWrapper :curr-message="reply" />
      </template>
    </template>
  </div>
  <div class="relative mx-1">
    <TextEditorVue :sendMessage="sendMessage" />
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import TextEditorVue from '../editor/TextEditor.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useThreadStore } from '../../../stores/useThreadStore';
import { conversation } from '../../../modules/axios/editorapi';
import ThreadHeader from './ThreadHeader.vue';
import { getMessageHistory } from '../../../modules/socket/messageHistory';
import { useCurrentUserStore } from '../../../stores/useCurrentUserStore';
import { storeToRefs } from 'pinia';

export default {
  name: 'RightPane',
  components: {
    MessageWrapper,
    NDivider,
    Editor,
    ThreadHeader,
    TextEditorVue
  },
  setup() {
    const threadStore = useThreadStore();
    const currentUserStore = useCurrentUserStore()
    const { currentUser } = storeToRefs(currentUserStore);
    return { threadStore, currentUser };
  },

  data() {
    return {
      newMessage: '',
      id: window.location.pathname.split('/')[2],
      conversation_type: window.location.pathname.split('/')[1],
    };
  },
  computed: {
    repliesCount() {
      return this.threadStore.message.replies.length + ' replies';
    },
  },
  methods: {
    sendMessage(message, files) {
      let formData = new FormData();
      formData.append('sender_id', 1);
      formData.append('content', message);
      formData.append('is_threaded', false);
      formData.append('parent_message_id', this.threadStore.message.id);
      formData.append('conversation_type', this.conversation_type);
      formData.append('conversation_id', this.id);
      files.forEach(file => {
        formData.append('message_attachments[]', file);
      });
      conversation(formData).then(async () => {
        const messages = await getMessageHistory(this.conversation_type.slice(0, -1), this.id);
        this.threadStore.message = messages.find(
          msg => msg.id === this.threadStore.message.id
        );
      });
    },
  },
};
</script>
<style scoped>
.chatBody {
  max-height: 64.5vh;
}
</style>
