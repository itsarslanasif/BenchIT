<template>
  <div class="grid grid-cols-1 border-b border-primary">
    <span class="flex justify-between">
      <div class="p-2 text-black-900 font-semibold text-xl">
        {{ $t('sidebar.threads') }}
      </div>
    </span>
  </div>
  <div class="overflow-auto h-screen">
    <div v-if="threadStore.threads" class="m-4">
      <div
        class="m-4 rounded-xl border-transparent border shadow-inner overflow-hidden"
        v-for="message in threadStore.threads"
        :key="message.id"
      >
        {{ setMessage(message) }}
        <div class="p-2 px-4 bg-transparent">
          <div class="text-lg flex gap-1 text-primary font-semibold">
            <div
              v-if="isProfileMessage"
              class="rounded-xl text-xs self-center"
              :class="isActive ? 'text-green-700' : 'text-black'"
            >
              <i class="fa-solid fa-circle"></i>
            </div>
            <div v-else-if="isChannelMessage">
              <font-awesome-icon v-if="isPrivate" icon="fa-lock" />
              <font-awesome-icon v-else icon="fa-hashtag" />
            </div>
            <div v-else-if="isGroupMessage">
              <font-awesome-icon icon="fas fa-users" />
              {{ currMessage.sender_name }}
            </div>
            <p v-if="!isGroupMessage">{{ conversationName }}</p>
          </div>
          <p class="text-xs text-black-600 font-normal self-center">
            {{ threadParticipants }}
          </p>
        </div>
        <MessageWrapper
          :conversationType="currMessage.conversationable_type"
          :conversationId="currMessage.conversationable_id"
          :fromThreadPage="true"
          :currMessage="currMessage"
        />
        <div v-for="reply in message.replies" :key="reply.id">
          <MessageWrapper
            :inThread="true"
            :fromThreadPage="true"
            :currMessage="reply"
          />
        </div>
        <div class="p-4">
          <TextEditor
            :isThread="true"
            :sendMessage="sendMessage"
            :fromThreads="true"
            :conversationType="currMessage.conversationable_type"
            :conversationId="currMessage.conversationable_id"
            :parentMessageId="currMessage.id"
          />
        </div>
      </div>
    </div>
    <div class="flex flex-col gap-2 justify-center items-center m-10" v-else>
      <font-awesome-icon
        icon="fa-regular fa-comment"
        class="font-bold text-xl"
      />
      <p class="font-semibold text-lg">
        {{ $t('sidebar.no_threads_to_show') }}
      </p>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
import { storeToRefs } from 'pinia';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { getThreads } from '../../api/threads/threads.js';
import MessageWrapper from '../components/messages/MessageWrapper.vue';
import TextEditor from '../components/editor/TextEditor.vue';
import { conversation } from '../../modules/axios/editorapi';
import { useThreadStore } from '../../stores/useThreadStore';
import { CONSTANTS } from '../../assets/constants';
export default {
  components: { NAvatar, MessageWrapper, TextEditor },
  data() {
    return {
      messages: [],
      currMessage: {},
      prevMessage: {},
      parentMessage: {},
      message: '',
      newMessageSent: false,
      conversation: {},
      conversationType: null,
      conversationId: null,
    };
  },
  setup() {
    const currentProfileStore = useCurrentProfileStore();
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const leftPaneStore = useLeftpaneStore();
    const threadStore = useThreadStore();
    const messageStore = useMessageStore();
    const { currentProfile } = storeToRefs(currentProfileStore);
    const { profiles } = storeToRefs(profileStore);
    const { joinedChannels } = storeToRefs(channelStore);
    return {
      currentProfile,
      leftPaneStore,
      messageStore,
      profiles,
      channels: joinedChannels,
      threadStore,
    };
  },
  async mounted() {
    let threads = await getThreads();
    this.threadStore.setThreads(threads);
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.currMessage;
      this.currMessage = message;
    },
    getConversationType(type) {
      switch (type) {
        case 'BenchChannel':
          return 'channels';
        case 'Profile':
          return 'profiles';
        case 'Group':
          return 'groups';
        default:
          return;
      }
    },
    getFileFromBlob(blob, fileName) {
      const file = new File([blob], fileName, { type: blob.type });
      return file;
    },
    sendMessage(
      message,
      files,
      conversation_type,
      conversation_id,
      parent_message_id
    ) {
      let formData = new FormData();
      formData.append('content', JSON.stringify(message));
      formData.append('is_threaded', true);
      formData.append('parent_message_id', parent_message_id);
      formData.append(
        'conversation_type',
        this.getConversationType(conversation_type)
      );
      formData.append('conversation_id', conversation_id);
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
      try {
        conversation(formData).then(() => {
          this.message = '';
        });
        this.newMessageSent = true;
      } catch (e) {
        console.error(e);
      }
    },
    removeDuplicates(list) {
      return list.filter(
        (item, index, newList) => newList.indexOf(item) === index
      );
    },
  },
  computed: {
    isToday() {
      return (
        new Date(this.currMessage.created_at).toDateString() ===
        new Date().toDateString()
      );
    },
    isOwnMessage() {
      return this.currMessage.sender_id === this.currentProfile.id;
    },
    time() {
      return moment(new Date(this.currMessage.created_at).getTime()).format(
        'h:mm A'
      );
    },
    isSameConversationMessage() {
      const currConversationName =
        this.currMessage.channel_name || this.currMessage.receiver_name;
      const prevConversationName =
        this.prevMessage.channel_name || this.prevMessage.receiver_name;
      return currConversationName === prevConversationName;
    },
    isFirstMessage() {
      return this.messages?.[0]?.id === this.currMessage.id;
    },
    conversationName() {
      const { channel_name, receiver_name, sender_name } = this.currMessage;
      return channel_name || (this.isOwnMessage ? receiver_name : sender_name);
    },
    isActive() {
      const profile = this.profiles.find(
        profile => profile.id === this.currMessage.sender_id
      );
      return profile ? profile.is_active : null;
    },
    isPrivate() {
      const channel = this.channels.find(
        channel => channel.id === this.currMessage.conversationable_id
      );
      return channel ? channel.is_private : null;
    },
    threadParticipants() {
      if (!this.currMessage.parent_message_id) {
        let participants = [this.currMessage.sender_name];
        this.currMessage.replies?.forEach(reply => {
          if (!participants.includes(reply.sender_name)) {
            if (reply.sender_id === this.currentProfile.id) {
              participants.push('You');
            } else {
              participants.push(reply.sender_name);
            }
          }
        });
        participants = this.removeDuplicates(participants);
        switch (participants.length) {
          case 1:
            return CONSTANTS.JUST_YOU;
          case 2:
            return `${participants[0]} ${CONSTANTS.AND} ${participants[1]}`;
          default:
            return `${participants[0]}, ${participants[1]}, ${CONSTANTS.AND} ${
              participants.length - 2
            } ${CONSTANTS.OTHERS}`;
        }
      }
      return '';
    },
    isProfileMessage() {
      return this.currMessage.conversationable_type === 'Profile';
    },
    isChannelMessage() {
      return this.currMessage.conversationable_type === 'BenchChannel';
    },
    isGroupMessage() {
      return this.currMessage.conversationable_type === 'Group';
    },
  },
};
</script>
