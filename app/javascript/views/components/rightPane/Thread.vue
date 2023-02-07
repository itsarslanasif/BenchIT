<template>
  <div>
    <right-pane-header
      :paneTitle="
        threadStore.message.receiver_name || threadStore.message.channel_name
      "
      :messageId="threadStore.message.id"
    />
    <div class="overflow-auto threadBody">
      <div class="pt-8">
        <MessageWrapper :inThread="true" :curr-message="threadStore.message" />
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
          <div :id="reply.id">
            <MessageWrapper
              :id="reply.id"
              :inThread="true"
              :curr-message="reply"
            />
          </div>
        </template>
      </template>
    </div>
    <div
      class="relative mx-1"
      :class="{ 'mt-10': !threadStore.message.replies.length }"
    >
      <TextEditorVue :isThread="true" :sendMessage="sendMessage" />
    </div>
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import TextEditorVue from '../editor/TextEditor.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useThreadStore } from '../../../stores/useThreadStore';
import { conversation } from '../../../modules/axios/editorapi';
import RightPaneHeader from './RightPaneHeader.vue';
import { useUserInviteStore } from '../../../stores/useUserInviteStore';
import { storeToRefs } from 'pinia';
import { CONSTANTS } from '../../../assets/constants';

export default {
  name: 'RightPane',
  components: {
    MessageWrapper,
    NDivider,
    Editor,
    RightPaneHeader,
    TextEditorVue,
  },
  setup() {
    const threadStore = useThreadStore();
    const currentUserStore = useUserInviteStore();
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
      let count = this.threadStore.message.replies.length;
      return count > 1
        ? `${count} ${CONSTANTS.REPLIES}`
        : `${count} ${CONSTANTS.REPLY}`;
    },
    replyExist() {
      return this.threadStore.message.replies.length > 1;
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
        formData.append('message_attachments[]', file, message);
      });
      try {
        conversation(formData);
      } catch (e) {
        console.error(e);
      }
    },
  },
  mounted() {
    const message_id = this.$route.params.message_id;
    if (message_id) {
      const message = document.getElementById(message_id);
      message.scrollIntoView({ block: 'center' });
      message.classList.add('highlight');
    }
  },
};
</script>
<style scoped>
.threadBody {
  max-height: 67vh;
}
.mt-10 {
  margin-top: 60px;
}

.highlight {
  animation: background-fade 5s;
}

@keyframes background-fade {
  0% {
    background: rgba(236, 219, 145, 0.789);
  }
}
</style>
