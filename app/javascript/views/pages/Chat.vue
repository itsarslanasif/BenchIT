<template>
  <div class="">
    <div v-if="chat">
      <ChatHeader />
    </div>
    <div v-if="messages" class="h-1/2 break-words">
      <ChatBody />
    </div>
    <div class="h-3/4">
      <div class="m-4 pt-6">
        <div v-if="showMentions || showChannels"
          class="w-1/4 p-2 text-sm shadow-inner bg-secondary text-white absolute z-10">
          <div v-if="(showMentions && hasMentionCommand) || (showChannels && hasChannelCommand)">
            <div v-for="item in filteredList" :key="item.name" class="p-1 rounded-md hover:bg-secondaryHover"
              @click="addMentionToText">
              {{ item.name }}
            </div>
          </div>
        </div>
        <div class="relative">
          <editor v-model="message" api-key="{{import.meta.env.VITE_EDITOR_API}}" :init="{
            menubar: false,
            statusbar: false,
            plugins: 'lists link code',
            toolbar:
              'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code',
          }" />
        </div>
        <button @click="sendMessage"
          class="float-right px-6 py-2 bg-success m-3 rounded-md text-white hover:bg-successHover">
          {{ $t('actions.send') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { useProfileStore } from '../../stores/useProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';
import ChatHeader from '../components/chats/ChatHeader.vue';
import { NInput, NSpace } from 'naive-ui';
import ChatBody from '../components/chats/ChatBody.vue';
import Editor from '@tinymce/tinymce-vue';
import { createCable } from '@/plugins/cable';
import { conversation } from '../../modules/axios/editorapi';
import { useMessageStore } from '../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';

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
      message: '',
      plainText: '',
      hasMentionCommand: false,
      hasChannelCommand: false,
      showMentions: false,
      showChannels: false,
      allProfiles: [],
      allChannels: [],
      chat: {},
      messages: [],
      Cable: null,
      conversation_type: null,
      id: null,
      filteredList: []
    };
  },
  setup() {
    function getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    }
    const messageStore = useMessageStore();
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const conversation_type = getIndexByParams(1)
    const id = getIndexByParams(2)
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    const { messages } = storeToRefs(messageStore);
    messageStore.index(conversation_type, id);
    return {
      allProfiles: profiles,
      allChannels: channels,
      messages,
      conversation_type,
      id
    };
  },
  mounted() {
    this.Cable = createCable({
      channel: 'ChatChannel',
      id: this.id,
      type: this.conversation_type,
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
      this.filteredList = this.filteredList.filter(item => item.name.toLowerCase().includes(lastWord.slice(1).toLowerCase()))
    },
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
      const findMessage = this.messages.find(m => m.id === data.message.id);

      if (findMessage == undefined) {
        this.messages.push(data.message);
        this.message = '';
      }
    });
  },

  methods: {
    sendMessage() {
      const payload = {
        sender_id: 1,
        content: this.message.replace(/<[^>]+>/g, ''),
        is_threaded: false,
        parent_message_id: null,
        conversation_type: this.conversation_type,
        conversation_id: this.id,
      };
      conversation(payload);
    },

    enableMention() {
      this.allProfiles = this.allProfiles.filter(profile => profile.name !== null)
      this.filteredList = this.allProfiles
      this.hasMentionCommand = true;
      this.showMentions = true;
      this.hasChannelCommand = false;
      this.showChannels = false;
    },

    enableChannels() {
      this.filteredList = this.allChannels
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
};
</script>

<style>
.editor {
  bottom: 0;
  float: left;
  width: 100%;
}
</style>
