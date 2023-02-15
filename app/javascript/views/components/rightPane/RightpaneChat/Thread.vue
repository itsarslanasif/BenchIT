<template>
  <div class="m-3 border border-black-500 rounded shadow-inner">
    <right-pane-header
      :paneTitle="
        threadStore.message.receiver_name || threadStore.message.channel_name
      "
      :messageId="threadStore.message.id"
    />
    <div class="overflow-auto threadBody">
      <div class="pt-8">
        <MessageWrapper
          :inThread="true"
          :curr-message="threadStore.message"
          :messageStore="messageStore"
          :userProfileStore="userProfileStore"
          :toggleUserProfileShow="rightPaneStore.toggleRightPaneUserProfileShow"
          :pinnedConversationStore="pinnedConversationStore"
        />
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
              :messageStore="messageStore"
              :userProfileStore="userProfileStore"
              :toggleUserProfileShow="
                rightPaneStore.toggleRightPaneUserProfileShow
              "
              :pinnedConversationStore="pinnedConversationStore"
            />
          </div>
        </template>
      </template>
    </div>
    <div class="relative mx-1">
      <TextEditorVue
        :sendMessage="sendMessage"
        :isThread="true"
        :selectedChat="messageStore.selectedChat"
      />
    </div>
  </div>
</template>

<script>
import MessageWrapper from '../../messages/MessageWrapper.vue';
import TextEditorVue from '../../editor/TextEditor.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useRightPaneThreadStore } from '../../../../stores/useRightPaneThreadStore';
import { conversation } from '../../../../modules/axios/editorapi';
import RightPaneHeader from './RightPaneHeader.vue';
import { useUserInviteStore } from '../../../../stores/useUserInviteStore';
import { storeToRefs } from 'pinia';
import { CONSTANTS } from '../../../../assets/constants';
import { useRightpaneMessageStore } from '../../../../stores/useRightpaneMessageStore';
import { useRightPaneUserProfileStore } from '../../../../stores/useRightPaneProfileStore';
import { useRightPaneStore } from '../../../../stores/useRightPaneStore';
import { useRightPanePinnedConversation } from '../../../../stores/useRightPanePinnedConversationStore';

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
    const threadStore = useRightPaneThreadStore();
    const currentUserStore = useUserInviteStore();
    const messageStore = useRightpaneMessageStore();
    const userProfileStore = useRightPaneUserProfileStore();
    const rightPaneStore = useRightPaneStore();
    const pinnedConversationStore = useRightPanePinnedConversation();
    const { currentUser } = storeToRefs(currentUserStore);
    return {
      threadStore,
      currentUser,
      messageStore,
      userProfileStore,
      rightPaneStore,
      pinnedConversationStore,
    };
  },

  data() {
    return {
      newMessage: '',
      conversation_type: '',
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
  },
  methods: {
    sendMessage(message, files) {
      let formData = new FormData();
      formData.append('sender_id', 1);
      formData.append('content', message);
      formData.append('is_threaded', false);
      formData.append('parent_message_id', this.threadStore.message.id);
      formData.append('conversation_type', this.conversation_type);
      formData.append('conversation_id', this.messageStore.selectedChat.id);
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
  mounted() {
    this.conversation_type =
      this.messageStore.selectedChat.is_private !== undefined
        ? 'channels'
        : 'profiles';
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

.highlight {
  animation: background-fade 5s;
}

@keyframes background-fade {
  0% {
    background: rgba(236, 219, 145, 0.789);
  }
}
</style>
