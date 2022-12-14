<template>
  <div>
    <div v-if="conversation_type && id">
      <div v-if="chat">
        <ChatHeader />
      </div>
      <div v-if="messages" class="h-1/2 break-words">
        <ChatBody />
      </div>
      <div class="h-3/4">
        <div class="m-4 pt-6">
          <div
            v-if="showMentions || showChannels"
            class="w-1/4 p-2 text-sm shadow-inner bg-secondary text-white absolute z-10"
          >
            <div
              v-if="
                (showMentions && hasMentionCommand) ||
                (showChannels && hasChannelCommand)
              "
            >
              <div
                v-for="item in filteredList"
                :key="item.name"
                class="p-1 rounded-md hover:bg-secondaryHover"
                @click="addMentionToText"
              >
                {{ item.name }}
              </div>
            </div>
          </div>
          <div class="relative">
            <editor
              v-model="message"
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
            <div v-if="readerFile.length" class="flex mt-2">
              <div
                v-for="file in readerFile"
                :key="file"
                class="w-12 h-12 border-primary border mr-3 rounded-md"
              >
                <font-awesome-icon
                  icon="fa-circle-xmark"
                  class="float-right"
                  @click="removeFile(file)"
                />
                <img :src="file" class="self-baseline" />
              </div>
            </div>
          </div>
          <div class="flex w-full relative">
            <Attachments :getImages="getImages" />
            <div class="w-1/12">
              <button
                @click="sendMessage"
                class="px-6 py-2 bg-success my-3 rounded-md text-white hover:bg-successHover"
              >
                {{ $t('actions.send') }}
              </button>
            </div>
          </div>
        </div>
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
import { useCurrentUserStore } from '../../stores/CurrentUserStore';
import { storeToRefs } from 'pinia';
import LandingPage from '../components/landingPage/landingPage.vue';
import Attachments from '../components/attachments/Attachments.vue';
import { forEach } from 'lodash';
export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    NInput,
    NSpace,
    LandingPage,
    editor: Editor,
    Attachments,
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
      currentUser: {},
      filteredList: [],
      openAttach: false,
      files: [],
      readerFile: [],
    };
  },
  setup() {
    function getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    }
    const messageStore = useMessageStore();
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const currentUserStore = useCurrentUserStore();
    const conversation_type = getIndexByParams(1);
    const id = getIndexByParams(2);
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    const { messages } = storeToRefs(messageStore);
    const { currentUser } = storeToRefs(currentUserStore);
    messageStore.index(conversation_type, id);
    return {
      allProfiles: profiles,
      allChannels: channels,
      messages,
      conversation_type,
      currentUser,
      id,
    };
  },
  mounted() {
    this.Cable = createCable({
      channel: 'ChatChannel',
      id: this.id,
      type: this.conversation_type,
      current_user_id: this.currentUser.id,
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
      this.filteredList = this.filteredList.filter(item =>
        item.name.toLowerCase().includes(lastWord.slice(1).toLowerCase())
      );
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
      let formData = new FormData();
      formData.append('sender_id', this.currentUser.id)
      formData.append('content', this.message.replace(/<[^>]+>/g, ''))
      formData.append('is_threaded', false)
      formData.append('parent_message_id', null)
      formData.append('conversation_type', this.conversation_type)
      formData.append('conversation_id', this.id)
      this.files.forEach(file => {
        formData.append('message_attachments[]', file)
      })
      conversation(formData);
      this.message = '';
      this.files = [],
      this.readerFile = []
    },

    removeFile(file) {
      const index = this.readerFile.indexOf(file)
      this.files.splice(index, 1)
      this.readerFile.splice(index, 1)
    },

    getImages(files) {
      console.log(files)
      this.files[this.files.length] = files;
      const reader = new FileReader();
      reader.readAsDataURL(files);
      reader.onload = () => this.readerFile.push(reader.result);
    },

    enableMention() {
      this.allProfiles = this.allProfiles.filter(
        profile => profile.name !== null
      );
      this.filteredList = this.allProfiles;
      this.hasMentionCommand = true;
      this.showMentions = true;
      this.hasChannelCommand = false;
      this.showChannels = false;
    },

    enableChannels() {
      this.filteredList = this.allChannels;
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

.mce-i-codesample {
  color: transparent !important;
  background-image: url(../../assets/images/codeblock.png) !important;
}
</style>
