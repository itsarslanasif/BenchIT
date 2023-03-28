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
        v-if="threadStore.message.replies.length"
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
    <div class="relative mx-1">
      <TextEditorVue
        ref="textEditor"
        :isThread="true"
        :sendMessage="sendMessage"
        :recieverName="recieverName"
      />
    </div>
  </div>
</template>

<script>
import MessageWrapper from '../messages/MessageWrapper.vue';
import TextEditorVue from '../editor/TextEditor.vue';
import { NDivider } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import { useThreadStore } from '../../../stores/useThreadStore';
import { useProfileStore } from '../../../stores/useProfileStore';
import { conversation } from '../../../modules/axios/editorapi';
import RightPaneHeader from './RightPaneHeader.vue';
import { useDraftAndSentMessagesStore } from '../../../stores/useDraftAndSentMessagesStore';
import { useUserInviteStore } from '../../../stores/useUserInviteStore';
import { storeToRefs } from 'pinia';
import { Remarkable } from 'remarkable';
import { CONSTANTS } from '../../../assets/constants';
import { errorHandler } from '../../widgets/messageProvider';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { ref } from 'vue';

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
    const profileStore = useProfileStore();
    const messagesStore = useMessageStore();
    const draftAndSentMessagesStore = useDraftAndSentMessagesStore();
    const { currentUser } = storeToRefs(currentUserStore);
    const { selectedChat } = storeToRefs(messagesStore);
    const textEditor = ref(null);

    return { threadStore, currentUser, profileStore, selectedChat, draftAndSentMessagesStore, textEditor };
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
    recieverName() {
      return (
        this.threadStore.message.receiver_name ||
        this.threadStore.message.channel_name
      );
    },
  },
  methods: {
    getFileFromBlob(blob, fileName) {
      const file = new File([blob], fileName, { type: blob.type });
      return file;
    },
    async sendMessage(message, files, isDraft) {
      if (message.blocks[0] != undefined) {
        let profileList = await Promise.all(
          message.blocks.map(async block => {
            return await this.getMentionedUsers(block);
          })
        );
        profileList = profileList.flat(2);
        profileList = profileList.map(profile => {
          return profile.id;
        });
        let formData = new FormData();
        formData.append('sender_id', 1);
        formData.append('content', JSON.stringify(message));
        formData.append('is_threaded', false);
        formData.append('parent_message_id', this.threadStore.message.id);
        formData.append('conversation_type', this.conversation_type);
        formData.append('conversation_id', this.id);
        if (profileList.length != 0) {
          formData.append('profile_list[]', profileList);
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
          } else {
            filename += `.${fileExtension}`;
          }
          formData.append('message_attachments[]', file, filename);
        });
        try {
          if (!isDraft) {
            conversation(formData);
          } else {
            this.draftAndSentMessagesStore.createDraftMessage(formData);
          }
        } catch (e) {
          errorHandler(e.response.data.message);
        }
      } else {
        return false;
      }
    },
    async getMentionedUsers(section) {
      const html = new Remarkable({ html: true });
      const { profiles } = await this.profileStore.getMentionsFromIds(
        html.render(section.text.text)
      );
      return profiles;
    },
    async insertDraft() {
      const html = new Remarkable({ html: true });
      const draftMessageBlocks = JSON.parse(this.messageStore.selectedChat.draft_message.content).blocks
      const draftMessageText = draftMessageBlocks.map((section)=>{
        return html.render(section.text.text)
      })
      this.textEditor.editor.commands.setContent(...draftMessageText)
    }
  },
  mounted() {
    const message_id = this.$route.params.message_id;
    if (message_id) {
      const message = document.getElementById(message_id);
      message.scrollIntoView({ block: 'center' });
      message.classList.add('highlight');
    }
    this.insertDraft()
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
