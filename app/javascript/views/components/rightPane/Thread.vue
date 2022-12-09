<template>
  <thread-header
    :threadName="threadStore.message.receiver_name || threadStore.message.channel_name"
    :messageId="threadStore.message.id"
  />
  <div class="overflow-auto chatBody">
    <div class="pt-8">
      <MessageWrapper :curr-message="threadStore.message" />
    </div>
    <n-divider
      v-if="threadStore.message.replies"
      title-placement="left"
      class="text-black-500 text-xs"
    >
      <p>{{ repliesCount }}</p>
    </n-divider>
    <template v-if="threadStore.message.replies">
      <template v-for="reply in threadStore.message.replies" :key="reply.id">
        <MessageWrapper :curr-message="reply" />
      </template>
    </template>
  </div>
  <div class="relative mx-1">
    <editor
      v-model="newMessage"
      api-key="{{process.env.VITE_EDITOR_API}}"
      :init="{
        menubar: false,
        statusbar: false,
        plugins: 'lists link code',
        toolbar:
          'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code',
      }"
    />
  </div>
  <button
    @click="sendMessage"
    class="float-right px-6 py-2 bg-success m-3 rounded-md text-white hover:bg-successHover"
  >
    {{ $t('rightpane.send') }}
  </button>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useThreadStore } from '../../../stores/ThreadStore';
import { conversation } from '../../../modules/axios/editorapi';
import ThreadHeader from './ThreadHeader.vue';
import { getMessageHistory } from '../../../modules/socket/messageHistory';

export default {
  name: 'RightPane',
  components: {
    MessageWrapper,
    NDivider,
    Editor,
    ThreadHeader,
  },
  setup() {
    const threadStore = useThreadStore();
    return { threadStore };
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
  async updated() {
    const messages = await getMessageHistory(this.conversation_type, this.id);
    this.threadStore.message = messages.find(
      msg => msg.id === this.threadStore.message.id
    );
  },
  methods: {
    sendMessage() {
      const payload = {
        sender_id: 1,
        content: this.newMessage,
        is_threaded: false,
        parent_message_id: this.threadStore.message.id,
        conversation_type: this.conversation_type,
        conversation_id: this.id,
      };
      conversation(payload).then(() => {
        this.newMessage = '';
      });
    },
  },
};
</script>
<style scoped>
.chatBody {
  max-height: 62vh;
}
</style>
