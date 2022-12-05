<template>
  <div class="mt-4">
    <MessageWrapper :curr-message="threadStore.message" />
    <n-divider v-if="threadStore.message.replies" title-placement="left">
      <p class="text-gray-600">{{ replies }}</p>
    </n-divider>
    <template v-if="threadStore.message.replies">
      <template v-for="reply in threadStore.message.replies" :key="reply.id">
        <MessageWrapper :curr-message="reply" />
      </template>
    </template>
    <div class="relative m-2">
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
      class="
        float-right
        px-6
        py-2
        bg-success
        m-3
        rounded-md
        text-white
        hover:bg-successHover
      "
    >
      {{ $t('rightpane.send') }}
    </button>
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useThreadStore } from '../../../stores/ThreadStore';
import { conversation } from '../../../modules/axios/editorapi';
export default {
  name: 'RightPane',
  components: {
    MessageWrapper,
    NDivider,
    Editor,
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
    replies() {
      return this.threadStore.message.replies.length + ' replies';
    },
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
      conversation(payload);
    },
  },
};
</script>

<style scoped>
</style>
