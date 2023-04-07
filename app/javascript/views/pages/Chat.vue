<template>
  <div
    v-if="conversation_type && id"
    class="flex flex-col h-full justify-between"
  >
    <div v-if="chat">
      <ChatHeader />
    </div>
    <div v-if="messages" class="break-words chat-style overflow-y-auto">
      <ChatBody
        @load-more-messages="loadMoreMessages"
        :oldestUnreadMessageId="oldestUnreadMessageId"
      />
    </div>
    <div class="px-3" v-if="isMember">
      <TextEditor
        ref="textEditor"
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
import { Remarkable } from 'remarkable';
import ChatBody from '../components/chats/ChatBody.vue';
import TextEditor from '../components/editor/TextEditor.vue';
import { createCable, unsubscribe } from '@/plugins/cable';
import { conversation } from '../../modules/axios/editorapi';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useCurrentUserStore } from '../../stores/useCurrentUserStore';
import { cableActions } from '../../modules/cable';
import { storeToRefs } from 'pinia';
import { useUnreadStore } from '../../stores/useUnreadStore';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import { useConnectionStore } from '../../stores/useConnectionStore';
import { useDraftAndSentMessagesStore } from '../../stores/useDraftAndSentMessagesStore';
import { ref, onMounted } from 'vue';

export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    NInput,
    NSpace,
    TextEditor,
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
    const textEditor = ref(null);
    const messageStore = useMessageStore();
    const currentUserStore = useCurrentUserStore();
    const profileStore = useProfileStore();
    const unreadStore = useUnreadStore();
    const connectionStore = useConnectionStore();
    const channelDetailStore = useChannelDetailStore();
    const currentProfileStore = useCurrentProfileStore();
    const draftAndSentMessagesStore = useDraftAndSentMessagesStore();
    const conversation_type = getIndexByParams(1);
    const id = getIndexByParams(2);
    const {
      messages,
      currMessage,
      currentPage,
      hasMoreMessages,
      newMessageSent,
    } = storeToRefs(messageStore);
    const { isConnected } = storeToRefs(connectionStore);
    const { currentUser } = storeToRefs(currentUserStore);
    const { channelMembers } = storeToRefs(channelDetailStore);
    const currentProfile = currentProfileStore.getCurrentProfile;
    const oldestUnreadMessageId = unreadStore.getOldestMessageId(
      conversation_type,
      id
    );
    unreadStore.markedChatAsRead(conversation_type, id);
    const { selectedChat } = storeToRefs(messageStore);

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
      profileStore,
      isConnected,
      connectionStore,
      textEditor,
      selectedChat,
      draftAndSentMessagesStore,
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
      current_profile_id: this.currentProfile.id,
    });
    this.Cable.on('chat', data => {
      cableActions(data.message);
    });
    if (this.messageStore.selectedChat.draft_message) {
      this.insertDraft();
    }
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
    async sendMessage(message, files, schedule, isDraft) {
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
        formData.append('content', JSON.stringify(message));
        formData.append('is_threaded', false);
        formData.append('conversation_type', this.conversation_type);
        formData.append('conversation_id', this.id);
        if (profileList.length != 0) {
          formData.append('profile_list[]', profileList);
        }
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

        if (this.isConnected) {
          if (!isDraft) {
            conversation(formData).then(res => {
              if (res.scheduled_at) {
                this.messageStore.addScheduleMessage(res);
              }
              this.message = '';
            });
            this.newMessageSent = true;
          } else {
            this.draftAndSentMessagesStore.createDraftMessage(formData);
          }
        } else {
          this.connectionStore.unsendMessagesQueue(formData);
        }
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
    async getMentionedUsers(section) {
      const html = new Remarkable({ html: true });
      const { profiles } = await this.profileStore.getMentionsFromIds(
        html.render(section.text.text)
      );
      return profiles;
    },
    async insertDraft() {
      const html = new Remarkable({ html: true });
      const draftMessageBlocks = JSON.parse(
        this.messageStore.selectedChat.draft_message.content
      ).blocks;
      const draftMessageText = draftMessageBlocks.map(section => {
        return html.render(section.text.text);
      });
      this.textEditor.editor.commands.setContent(...draftMessageText);
    },
  },
};
</script>

<style scoped>
.chat-style {
  flex: 1;
}

.mce-i-codesample {
  color: transparent !important;
  background-image: url(../../assets/images/codeblock.png) !important;
}
</style>
