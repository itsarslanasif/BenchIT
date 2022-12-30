<template>
  <right-pane-header
    :paneTitle="
      threadStore.message.receiver_name || threadStore.message.channel_name
    "
    :messageId="threadStore.message.id"
  />
  <div class="overflow-auto threadBody">
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
      api-key="{{ import.meta.env.VITE_EDITOR_API }}"
      :init="{
        menubar: false,
        statusbar: false,
        plugins: 'lists link code codesample',
        toolbar:
          'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code | codesample',
        codesample_languages: [none],
        formats: {
          code: {
            selector: 'p',
            styles: {
              background:
                'rgba(var(--sk_foreground_min_solid, 248, 248, 248), 1)',
              'border-left':
                '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
              'border-right':
                '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
              'border-top':
                '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
              'border-bottom':
                '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
              'border-radius': '3px',
              'font-size': '10px',
              'font-variant-ligatures': 'none',
              'line-height': '1.5',
              'margin-bottom': '14px',
              'padding-left': '8px',
              'padding-right': '8px',
              position: 'relative',
              'font-family': 'monospace',
            },
          },
        },
      }"
    />
  </div>
  <button
    @click="sendMessage"
    class="float-right px-6 py-1 bg-success m-2 rounded-md text-white hover:bg-successHover"
  >
    {{ $t('rightpane.send') }}
  </button>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useThreadStore } from '../../../stores/useThreadStore';
import { conversation } from '../../../modules/axios/editorapi';
import RightPaneHeader from './RightPaneHeader.vue';
import { getMessageHistory } from '../../../modules/socket/messageHistory';
import { UserStore } from '../../../stores/user_store';
import { storeToRefs } from 'pinia';

export default {
  name: 'RightPane',
  components: {
    MessageWrapper,
    NDivider,
    Editor,
    RightPaneHeader,
  },
  setup() {
    const threadStore = useThreadStore();
    const currentUserStore = UserStore();
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
  beforeUnmount() {
    this.newMessage = null;
  },
  computed: {
    repliesCount() {
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
      conversation(payload).then(async () => {
        this.newMessage = '';
        const messages = await getMessageHistory(
          this.conversation_type.slice(0, -1),
          this.id
        );
        this.threadStore.message = messages.find(
          msg => msg.id === this.threadStore.message.id
        );
      });
    },
  },
};
</script>
<style scoped>
.threadBody {
  max-height: 67vh;
}
</style>
