<template>
  <ChatHeader :chat="chat" />
  <ChatBody :messages="messages" />
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
    <div @click="sendMessage" class="sendBtn">
      Send
    </div>
  </div>
</template>

<script>
import { UserStore } from '../../../stores/users';
import { ChannelStore } from '../../../stores/channels';
import ChatHeader from './ChatHeader.vue';
import ChatBody from './ChatBody.vue';
import { NInput, NSpace } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
import axios from './axios';
import { createCable } from '@/plugins/cable';
import { conversation } from '../../../api/editor/editorapi'

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
      chat: {},
      textMessage: '',
      messages: [],
      conversation_type: window.location.pathname.split('/')[1],
      id: window.location.pathname.split('/')[2],
      Cable: null,
    };
  },
  mounted() {
    axios
      .get(`${this.conversation_type}/${this.id}`)
      .then(response => {
        this.messages = response.data;
        this.chat = {
          id: this.messages[0]?.bench_conversation_id,
          name: this.messages[0]?.channel_name
            ? this.messages[0]?.channel_name
            : this.messages[0]?.group_id
              ? 'Group Chat ' + this.messages[0]?.group_id
              : this.messages[0]?.receiver_name,
          isActive: true,
          status: '',
          avatar:
            'data:image/png;base64,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',
        };
      })
      .catch(error => {
        this.error = error;
      });
    this.Cable = createCable({
      channel: 'ChatChannel',
      id: this.id,
    });
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
      chat: {},
      messages: [],
      conversation_type: window.location.pathname.split('/')[1],
      id: window.location.pathname.split('/')[2],
    };
  },

  updated() {
    this.Cable.on('chat', data => {
      if (this.conversation_type === 'channels') {
        data.message.channel_name = this.messages[0].channel_name;
      } else if (this.conversation_type === 'groups') {
        data.message.group_id = this.messages[0].group_id;
      } else {
        data.message.receiver_name = this.messages[0].receiver_name;
      }
      this.messages.push(data.message);
    });
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
    sendMessage() {
      const payload = {
        sender_id: 1,
        content: this.textMessage.replace(/<[^>]+>/g, ''),
        is_threaded: false,
        parent_message_id: null,
        conversation_type: this.conversation_type,
        conversation_id: this.id
      }
      conversation(payload)
    },

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

  updated() {
    this.Cable.on('chat', data => {
      if (this.conversation_type === 'channels') {
        data.message.channel_name = this.messages[0].channel_name;
      } else if (this.conversation_type === 'groups') {
        data.message.group_id = this.messages[0].group_id;
      } else {
        data.message.receiver_name = this.messages[0].receiver_name;
      }
      this.messages.push(data.message);
    });
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

  .sendBtn{
    background-color: #401A40;
    float: right;
    margin-right: 2%;
    margin-top: 5px;
    padding: 10px 20px;
    border-radius: 5px;
    font-weight: bold;
    color: white;
  }
</style>
