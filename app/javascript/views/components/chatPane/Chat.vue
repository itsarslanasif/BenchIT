<template>
  <ChatHeader :chat="chat" />
  <ChatBody />
  <div class="editor">
    <div v-if="showMentions && hasMentionCommand" class="mentions">
      <div v-for="user in allUsers" :key="user.username" @click="addMentionToText">
        {{ user.username }}
      </div>
    </div>
    <div v-if="showChannels && hasChannelCommand" class="mentions">
      <div v-for="channel in allChannels" :key="channel.name" @click="addChannelToText">
        {{ channel.name }}
      </div>
    </div>
    <editor api-key="{{process.env.VITE_EDITOR_API}}" v-model="message" :init="{
      menubar: false,
      statusbar: false,
      plugins: 'lists link code',
      toolbar:
        'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code',
    }" />
  </div>
</template>

<script>
import { UserStore } from '../../../stores/users';
import { ChannelStore } from '../../../stores/channels';
import ChatHeader from './ChatHeader.vue';
import chats from './data/chats';
import ChatBody from './ChatBody.vue';
import { NInput, NSpace } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';

export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    NInput,
    NSpace,
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
    const users = UserStore();
    const channels = ChannelStore();
    return {
      allUsers: Object.values(users.getUsers),
      allChannels: Object.values(channels.getChannels),
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

    .mentions {
      background-color: white;
      color: black;
    }
</style>
