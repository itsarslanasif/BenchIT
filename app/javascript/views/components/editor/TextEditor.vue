<template>
  <div>
    <AttachmentShortCutVue
      :isThread="isThread"
      class="margintop absolute z-10"
    />
    <CreateTextSnippetModal
      v-if="
        isThread
          ? attachmentAndShortcutStore.showCreateTextSnippitModalThread
          : attachmentAndShortcutStore.showCreateTextSnippitModal
      "
      :sendMessage="sendMessage"
      :isThread="isThread"
      :recieverName="fileRecieverName"
    />
    <div
      v-if="filteredList.length"
      class="w-1/4 p-2 text-sm shadow-inner bg-secondary text-white absolute z-10"
    >
      <!-- <div
        v-if="
          (showMentions && hasMentionCommand) ||
          (showChannels && hasChannelCommand)
        "
      > -->
      <div
        v-for="item in filteredList"
        :key="item.name"
        class="p-1 rounded-md hover:bg-secondaryHover"
        @click="addMentionToText"
      >
        {{ item.creator_id ? item.name : item.username }}
      </div>
      <!-- </div> -->
    </div>
    <div>
      <div
        v-if="schedule"
        class="bg-slate-50 border-l border-t border-r border-slate-100 px-2 py-1 rounded-t"
      >
        {{ getScheduleNotification() }}
      </div>
      <!-- <editor
        v-model="newMessage"
        @keydown.enter="sendMessagePayload"
        api-key="no-api-key"
        :init="{
          placeholder: getPlaceholder,
          menubar: false,
          statusbar: false,
          toolbar_location: 'bottom',
          toolbar1:
            'AddAttachments bold italic underline strikethrough | link |  bullist numlist  | alignleft | code | codesample | sendButton',
          setup: editor => {
            editor.ui.registry.addButton('AddAttachments', {
              text: '➕',
              onAction: handleCustomButton,
            });
          },
          plugins: ' lists link code codesample emoticons',
          codesample_languages: [none],
          formats: {
            code: {
              selector: 'p',
              styles: {
                background:
                  'rgba(var(--sk_foreground_min_solid, 248, 248, 248), 1)',
                border: '1px solid gray',
                'border-radius': '3px',
                'font-size': '10px',
                'font-variant-ligatures': 'none',
                'line-height': '1.5',
                'margin-bottom': '14px',
                padding: '0px 8px 0px 8px',
                position: 'relative',
                'font-family': 'monospace',
              },
            },
          },
        }"
      /> -->
      <div
        v-if="editor"
        class="overflow-auto flex bg-white justify-center flex-col p-2 rounded-lg border border-black-400 m-1 focus:border-primaryHover"
      >
        <div class="flex overflow-auto items-center gap-1">
          <button
            @click="editor.chain().focus().toggleBold().run()"
            :disabled="!editor.can().chain().focus().toggleBold().run()"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
            :class="{ 'bg-transparent': editor.isActive('bold') }"
          >
            <font-awesome-icon icon="fa-bold" />
          </button>
          <button
            @click="editor.chain().focus().toggleItalic().run()"
            :disabled="!editor.can().chain().focus().toggleItalic().run()"
            :class="{ 'bg-transparent': editor.isActive('italic') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-italic" />
          </button>
          <button
            @click="editor.chain().focus().toggleStrike().run()"
            :disabled="!editor.can().chain().focus().toggleStrike().run()"
            :class="{ 'bg-transparent': editor.isActive('strike') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-strikethrough" />
          </button>
          <div class="vl" />
          <button
            @click="setLink"
            :class="{ 'bg-transparent': editor.isActive('link') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-link" />
          </button>
          <div class="vl" />
          <button
            @click="editor.chain().focus().toggleOrderedList().run()"
            :class="{ 'bg-transparent': editor.isActive('orderedList') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-list-ol" />
          </button>
          <button
            @click="editor.chain().focus().toggleBulletList().run()"
            :class="{ 'bg-transparent': editor.isActive('bulletList') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-list" />
          </button>
          <div class="vl" />
          <button
            @click="editor.chain().focus().toggleBlockquote().run()"
            :class="{ 'bg-transparent': editor.isActive('blockquote') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-quote-right" />
          </button>
          <div class="vl" />
          <button
            @click="editor.chain().focus().toggleCode().run()"
            :disabled="!editor.can().chain().focus().toggleCode().run()"
            :class="{ 'bg-transparent': editor.isActive('code') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-code" />
          </button>
          <button
            @click="editor.chain().focus().toggleCodeBlock().run()"
            :class="{ 'bg-transparent': editor.isActive('codeBlock') }"
            class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
          >
            <font-awesome-icon icon="fa-laptop-code" />
          </button>
        </div>

        <editor-content
          :editor="editor"
          class="mt-4"
          @keydown.enter="sendMessagePayload"
        />

        <div>
          <div v-if="readerFile.length" class="flex gap-1 mt-2 relative">
            <div v-for="file in readerFile" :key="file" class="relative">
              <font-awesome-icon
                icon="fa-circle-xmark"
                class="absolute right-0 text-xs p-1 mb-6 text-white shadow-md"
                @click="removeFile(file)"
              />
              <img
                :src="file"
                class="self-baseline w-12 h-12 rounded-md border-black-600 border"
              />
            </div>
          </div>
        </div>

        <div v-if="scheduleModalFlag">
          <ScheduleModal
            :setSchedule="setSchedule"
            :toggleShow="toggleSchedule"
          />
        </div>

        <div class="flex justify-between mt-4">
          <div class="flex items-center gap-1">
            <button
              v-if="!editMessage"
              class="bg-transparent rounded-full focus:outline-none focus:bg-black-300"
            >
              <Attachments :getImages="getImages" />
            </button>
            <div v-if="!editMessage" class="vl" />
            <button
              v-if="!editMessage"
              class="px-2 py-1 hover:bg-transparent rounded italic focus:outline-none focus:bg-black-300"
            >
              <font-awesome-icon icon="fa-video" />
            </button>
            <button
              v-if="!editMessage"
              class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
            >
              <font-awesome-icon icon="fa-microphone" />
            </button>
            <div v-if="!editMessage" class="vl" />
            <button
              class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
            >
              <font-awesome-icon icon="fa-smile" />
            </button>
            <button
              v-if="!editMessage"
              class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
            >
              <font-awesome-icon icon="fa-at" />
            </button>
            <button
              class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
            >
              <font-awesome-icon icon="fa-toggle-off" />
            </button>
          </div>
          <div v-if="editMessage" class="flex gap-2 rounded items-center">
            <button
              @click="handleCancelEdit"
              class="px-2 py-1 font-semibold border border-black-600 hover:bg-transparent bg-white rounded focus:outline-none"
            >
              <p>Cancel</p>
            </button>
            <button
              @click="sendMessagePayload"
              class="px-2 py-1 font-semibold bg-success hover:bg-successHover border border-success rounded text-white focus:outline-none"
            >
              <p>Save</p>
            </button>
          </div>
          <div
            v-else
            class="flex rounded-md items-center"
            :class="editorContent ? 'bg-success' : 'bg-white'"
          >
            <button
              @click="sendMessagePayload($event, true)"
              class="px-2 py-1 rounded focus:outline-none"
              :class="
                editorContent
                  ? 'text-white bg-success hover:bg-successHover'
                  : 'text-black-500'
              "
            >
              <font-awesome-icon icon="fa-paper-plane" />
            </button>
            <div v-if="!isThread" class="vl" />
            <button
              v-if="!isThread"
              @click="toggleSchedule"
              class="px-2 py-1 rounded focus:outline-none"
              :class="
                editorContent
                  ? 'text-white bg-success hover:bg-successHover'
                  : 'text-black-500'
              "
            >
              <font-awesome-icon icon="fa-chevron-down" />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch } from 'vue';
import { markdownToBlocks } from '@tryfabric/mack';
import TurndownService from 'turndown';
import Attachments from '../attachments/Attachments.vue';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useChannelStore } from '../../../stores/useChannelStore';
import { useSearchStore } from '../../../stores/useSearchStore';
import { storeToRefs } from 'pinia';
import { NMention, NDivider } from 'naive-ui';
import ScheduleModal from '../../widgets/schedule.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';
import moment from 'moment';
import vClickOutside from 'click-outside-vue3';
import AttachmentShortCutVue from './Attachment&shortCutModal.vue';
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
import CreateTextSnippetModal from './CreateTextSnippetModal.vue';
import StarterKit from '@tiptap/starter-kit';
import Placeholder from '@tiptap/extension-placeholder';
import { Editor, EditorContent } from '@tiptap/vue-3';

export default {
  data() {
    return {
      editor: null,
    };
  },
  beforeMount() {
    if (this.message) {
      this.newMessage = this.message;
    }
  },
  beforeUnmount() {
    this.editor.destroy();
  },
  mounted() {
    this.editor = new Editor({
      extensions: [
        StarterKit,
        Placeholder.configure({
          placeholder: this.getPlaceholder,
        }),
      ],
      onUpdate: () => {
        this.editorContent = this.editor.getHTML();
      },
      content: this.newMessage,
    });
    if (this.isEditScheduled()) {
      this.newMessage = this.messageToEdit.content;
    }
  },
  components: {
    Attachments,
    NMention,
    ScheduleModal,
    AttachmentShortCutVue,
    CreateTextSnippetModal,
    EditorContent,
    NDivider,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  props: {
    sendMessage: {
      type: Object,
    },
    isThread: {
      type: Boolean,
    },
    editMessageCallBack: {
      type: Function,
    },
    editMessage: {
      type: Boolean,
    },
    message: {
      type: Object,
    },
    recieverName: {
      type: String,
    },
  },
  computed: {
    getPlaceholder() {
      return this.isThread
        ? this.$t('chat.reply_placeholder')
        : `${this.$t('actions.message')} ${this.getRecipientName}`;
    },
    getRecipientName() {
      return (
        this.getChannelName ||
        this.selectedChat.username ||
        this.$t('chat.empty_placeholder')
      );
    },
    getChannelName() {
      return this.selectedChat.name
        ? (this.selectedChat.is_private
            ? this.$t('chat.lock')
            : this.$t('chat.hash')) + this.selectedChat.name
        : false;
    },
    fileRecieverName() {
      return (
        this.recieverName || this.getChannelName || this.selectedChat.username
      );
    },
  },
  methods: {
    setLink() {
      const previousUrl = this.editor.getAttributes('link').href;
      const url = window.prompt('URL', previousUrl);
      if (url === null) {
        return;
      }
      if (url === '') {
        this.editor.chain().focus().extendMarkRange('link').unsetLink().run();
        return;
      }
      this.editor
        .chain()
        .focus()
        .extendMarkRange('link')
        .setLink({ href: url })
        .run();
    },

    async makeBlocks(line) {
      const block = await markdownToBlocks(line);
      return block[0];
    },

    async sendMessagePayload(event, buttonClicked) {
      if (
        ((event.keyCode === 13 && !event.shiftKey) || buttonClicked) &&
        !this.editMessage
      ) {
        const mrkdwn = [];
        const htmlList = this.editorContent.split('<br>');
        htmlList.forEach(async line => {
          line = line.replace(/<s>/g, '~~');
          line = line.replace(/<\/s>/g, '~~');
          mrkdwn.push(this.turndownService.turndown(line));
        });
        const result = await Promise.all(
          mrkdwn.map(async line => {
            line = line.replace(/\*\*/g, '****');
            return await this.makeBlocks(line);
          })
        );
        if (result[0] != null) {
          this.sendMessage({ blocks: result }, this.files, this.schedule);
          this.newMessage = '';
          this.readerFile = [];
          this.files = [];
          this.schedule = null;
        }
      }
    },
  },
  setup(props) {
    const channelStore = useChannelStore();
    const profileStore = useProfileStore();
    const searchStore = useSearchStore();
    const FilesStore = useRecentFilesStore();
    const turndownService = new TurndownService();
    const { channels } = storeToRefs(channelStore);
    const messageStore = useMessageStore();
    const { selectedChat, messageToEdit } = storeToRefs(messageStore);
    const { searches } = storeToRefs(searchStore);
    const scheduleModalFlag = ref(false);
    const { profiles } = storeToRefs(profileStore);
    const newMessage = ref('');
    const editorContent = ref('');
    const showMentions = ref(false);
    const showChannels = ref(false);
    const hasMentionCommand = ref(false);
    const hasChannelCommand = ref(false);
    const readerFile = ref([]);
    const files = ref([]);
    const filteredList = ref([]);
    const schedule = ref(null);
    const attachmentAndShortcutStore = useShortcutAndAttachmentStore();

    watch(editorContent, (curr, old) => {
      const currentMessage = ignoreHTML(curr);
      const oldMessage = ignoreHTML(old);
      const message = ignoreHTML(editorContent.value);

      if (message && getLastIndex(currentMessage)[0] == '@') {
        enableMention(message);
      } else if (message && getLastIndex(currentMessage)[0] == '#') {
        enableChannels(message);
      } else if (
        message.length === 1 &&
        getLastIndex(currentMessage)[0] == '@'
      ) {
        enableMention(message);
      } else if (
        message.length === 1 &&
        getLastIndex(currentMessage)[0] == '#'
      ) {
        enableChannels(message);
      } else {
        disableAll();
        searchStore.clearSearches();
      }
    });

    const getLastIndex = value => {
      return value.split(' ').pop();
    };

    const setSchedule = value => {
      schedule.value = value;
      toggleSchedule();
    };

    const dispatchKeydownEnterEvent = () => {
      const event = new KeyboardEvent('keydown', { keyCode: 13 });
      if (isEditScheduled()) {
        messageStore.reEditScheduledMessage({
          content: newMessage,
          id: messageToEdit.scheduledId,
        });
        newMessage.value = '';
      } else {
        sendMessagePayload(event);
      }
    };
    const handleCustomButton = () => {
      if (props.isThread) {
        attachmentAndShortcutStore.toggleModalInThread();
      } else {
        attachmentAndShortcutStore.toggleModalInChat();
      }
    };

    const handleCancelEdit = () => {
      messageStore.removeMessageToEdit();
    };

    const isEditScheduled = () =>
      messageToEdit.content &&
      messageToEdit.isScheduled &&
      messageToEdit.scheduledId;

    const message = newMessage => {
      let messageData;
      let filterData;
      let actuallData;
      const startWithBr = newMessage.value.startsWith('<p><br />', 0);
      const endWithBr = newMessage.value.endsWith('<br /></p>');
      const endWithBrAndP = newMessage.value.endsWith(
        '<br /></p>\n<p>&nbsp;</p>'
      );
      if (startWithBr || endWithBr || endWithBrAndP) {
        messageData = newMessage.value.split('<br />');
        filterData = messageData.filter(el => el !== '');
        actuallData = filterData.join().split('\n')[0].replace(/,/g, ' ');
      } else {
        actuallData = newMessage.value;
      }
      return actuallData;
    };

    const getScheduleNotification = () => {
      const date = moment(schedule.value);
      return `Your message will be sent to ${
        selectedChat.value['user_id']
          ? selectedChat.value.username
          : selectedChat.value.name
      } on ${date.format('MMMM DD, YYYY')} at ${date.format('h:mm A')}`;
    };

    const enableMention = async word => {
      const query = word.split(' ').pop().slice(1);
      await searchStore.index(query, 'Profile');
      filteredList.value = searches.value.profiles;
    };

    const enableChannels = async word => {
      const query = word.split(' ').pop().slice(1);
      await searchStore.index(query, 'BenchChannel');
      filteredList.value = searches.value.channels;
    };

    const disableAll = () => {
      hasMentionCommand.value = false;
      showMentions.value = false;
      hasChannelCommand.value = false;
      showChannels.value = false;
    };

    const addMentionToText = e => {
      // console.log(e.target.outerText);
      editorContent.value = `${editorContent.value.slice(0, -4)}${
        e.target.outerText
      } ${editorContent.value.slice(-4)}`;
      filteredList.value = false;
    };

    const ignoreHTML = message => {
      return message.replace(/<[^>]+>/g, '');
    };

    const removeFile = file => {
      const index = readerFile.value.indexOf(file);
      files.value.splice(index, 1);
      readerFile.value.splice(index, 1);
    };
    const getImages = file => {
      files.value[files.value?.length] = file;
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => readerFile.value.push(reader.result);
    };

    const toggleSchedule = () => {
      scheduleModalFlag.value = !scheduleModalFlag.value;
    };

    return {
      newMessage,
      readerFile,
      files,
      showMentions,
      showChannels,
      hasChannelCommand,
      hasMentionCommand,
      filteredList,
      channels,
      profiles,
      schedule,
      scheduleModalFlag,
      messageStore,
      messageToEdit,
      removeFile,
      getImages,
      addMentionToText,
      toggleSchedule,
      setSchedule,
      getScheduleNotification,
      dispatchKeydownEnterEvent,
      handleCancelEdit,
      isEditScheduled,
      selectedChat,
      handleCustomButton,
      attachmentAndShortcutStore,
      turndownService,
      editorContent,
    };
  },
};
</script>
<style lang="scss">
.ProseMirror p.is-editor-empty:first-child::before {
  content: attr(data-placeholder);
  float: left;
  color: #adb5bd;
  pointer-events: none;
  height: 0;
}

.ProseMirror p.is-editor-empty:first-child::before {
  content: attr(data-placeholder);
  float: left;
  color: #adb5bd;
  pointer-events: none;
  height: 0;
}
.ProseMirror {
  outline: none;
  > * + * {
    // margin-top: 0.75em;
  }
  ul {
    padding: 0 1rem;
    li {
      list-style: disc;
      li {
        list-style: circle;
        li {
          list-style: square;
        }
      }
    }
  }
  ol {
    padding: 0 1rem;
    li {
      list-style-type: style;
      li {
        list-style: lower-alpha;
      }
    }
  }

  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    line-height: 1.1;
  }

  code {
    background-color: #cec39e31;
    color: #e6a026;
    border-radius: 0.3rem;
    border-width: 0.02rem;
    border-color: #adb5bd;
    padding: 0.2rem;
  }

  pre {
    background: #5a4d041c;
    font-family: 'JetBrainsMono', monospace;
    color: #726933;
    padding: 0.75rem 1rem;
    border-radius: 0.3rem;
    border-width: 0.01rem;

    code {
      color: inherit;
      padding: 0;
      background: none;
      font-size: 0.8rem;
      border-width: 0;
    }
  }

  img {
    max-width: 100%;
    height: auto;
  }

  blockquote {
    padding-left: 1rem;
    border-left: 4px solid #b9996448;
  }

  hr {
    border: none;
    border-top: 2px solid rgba(#0d0d0d, 0.1);
    margin: 2rem 0;
  }
}
button {
  color: #474849;
}
.vl {
  border-left: 1px solid rgba(224, 226, 224, 0.752);
  height: 25px;
}
.margintop {
  margin-top: -270px;
}
</style>
