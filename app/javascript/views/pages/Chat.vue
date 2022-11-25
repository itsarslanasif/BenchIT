<template>
  <div class="">
    <div>
      <ChatHeader :chat="chat" />
    </div>
    <div class="h-1/2 break-words">
      <ChatBody />
    </div>
    <div class="h-3/4">
      <div class="m-4 pt-6">
        <div v-if="showMentions || showChannels"
          class="w-1/4 p-2 text-sm shadow-inner bg-secondary text-white absolute z-10">
          <div v-if="showMentions && hasMentionCommand" class="hover:bg-secondaryHover">
            <div v-for="user in allUsers" :key="user.username" class="p-1 rounded-md hover:bg-secondaryHover"
              @click="addMentionToText">
              {{ user.username }}
            </div>
          </div>
          <div v-if="showChannels && hasChannelCommand">
            <div v-for="channel in allChannels" :key="channel.name" class="p-1 rounded-sm hover:bg-secondaryHover"
              @click="addChannelToText">
              {{ channel.name }}
            </div>
          </div>
        </div>
        <div class="relative">
          <editor v-model="message" api-key="{{process.env.VITE_EDITOR_API}}" :init="{
            menubar: false,
            statusbar: false,
            plugins: 'lists link code',
            toolbar:
              'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code',
          }" />
        </div>
        <button class="float-right px-6 py-2 bg-success m-3 rounded-md text-white hover:bg-successHover">
          {{ $t(CONSTANTS.SEND) }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { useUserStore } from '../../stores/useUserStore';
import { useChannelStore } from '../../stores/useChannelStore';
import ChatHeader from '../components/chats/ChatHeader.vue';
import chats from '../../modules/data/chats';
import ChatBody from '../components/chats/ChatBody.vue';
import Editor from '@tinymce/tinymce-vue';
import { CONSTANTS } from '../../assets/constants';

export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    editor: Editor,
  },
  data() {
    return {
      chat: chats[1],
      message: '',
      plainText: '',
      hasMentionCommand: false,
      hasChannelCommand: false,
      showMentions: false,
      showChannels: false,
      allUsers: [],
      allChannels: [],
      CONSTANTS: CONSTANTS,
    };
  },

  watch: {
    message() {
      this.plainText = this.message.replace(/<[^>]+>/g, '');
      const words = this.plainText.split(' ');
      const lastWord = words[words.length - 1];
      if (lastWord[0] === '@') {
        this.enableMention();
      } else if (lastWord[0] === '#') {
        this.enableChannels();
      } else {
        this.disableAll();
      }
    },
  },

  methods: {
    enableMention() {
      this.hasMentionCommand = true;
      this.showMentions = true;
      this.hasChannelCommand = false;
      this.showChannels = false;
    },

    enableChannels() {
      this.hasChannelCommand = true;
      this.showChannels = true;
      this.hasMentionCommand = false;
      this.showMentions = false;
    },

    disableAll() {
      this.hasMentionCommand = false;
      this.showMentions = false;
      this.hasChannelCommand = false;
      this.showChannels = false;
    },

    addMentionToText(e) {
      e.preventDefault();
      this.ignoreHTML();
      this.message += e.target.outerText + ' ';
      this.showMentions = false;
      this.hasMentionCommand = false;
    },

    addChannelToText(e) {
      e.preventDefault();
      this.ignoreHTML();
      this.message += e.target.outerText + ' ';
      this.showChannels = false;
      this.hasChannelCommand = false;
    },

    ignoreHTML() {
      this.message = this.message.replace(/<[^>]+>/g, '');
    },
  },

  setup() {
    const userStore = useUserStore();
    const channelStore = useChannelStore();
    return {
      allUsers: Object.values(userStore.getUsers),
      allChannels: Object.values(channelStore.getChannels),
    };
  },
};
</script>
<style>
.editor {
  bottom: 0;
  float: left;
  width: 100%;
}
</style>
