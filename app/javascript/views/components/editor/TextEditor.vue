<template>
  <div :class="showTopBar ? '' : 'mt-8'">
    <div>
      <div
        v-if="schedule"
        class="bg-slate-50 border-l border-t border-r border-slate-100 px-2 py-1 rounded-t"
      >
        {{ getScheduleNotification() }}
      </div>
      <div
        v-if="editor"
        class="flex bg-white justify-center flex-col p-2 rounded-lg border border-black-300 m-1 focus:border-primaryHover"
      >
        <div
          v-show="showTopBar"
          class="flex overflow-y-auto overflow-x-hidden items-center gap-1"
        >
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
            <button @click="editor.chain().focus().splitListItem('listItem').run()" :disabled="!editor.can().splitListItem('listItem')">
               splitListItem
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
          @keydown.enter="sendMessagePayload"
          :editor="editor"
          class="mt-4"
        />

        <div>
          <div v-if="videoFiles.length" class="flex gap-1 mt-2 relative">
            <div v-for="file in videoFiles" :key="file" class="relative">
              <font-awesome-icon
                icon="fa-circle-xmark"
                class="absolute right-0 z-10 cursor-pointer"
                @click="removeVideoFiles(file)"
              />
              <VisualizeVideo :blob="file" />
            </div>
          </div>
        </div>

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
        <div>
          <div v-if="audioFiles.length" class="flex w-20 gap-1 mt-2 relative">
            <div v-for="file in audioFiles" :key="file" class="relative">
              <font-awesome-icon
                icon="fa-circle-xmark"
                class="absolute right-0"
                @click="removeAudioFile(file)"
              />
              <visualize-voice
                :fileID="new Date().getTime()"
                :audioURL="createURL(file)"
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
              <Attachments
                :getImages="getImages"
                :sendMessage="sendMessage"
                :isThread="isThread"
                :recieverName="fileRecieverName"
              />
            </button>
            <div v-if="!editMessage" class="vl" />
            <VideoRecord
              :getVideoFiles="getVideoFiles"
              :editMessage="editMessage"
            />
            <VoiceRecorder :getAudio="getAudio" v-if="!editMessage" />
            <div v-if="!editMessage" class="vl" />
            <button
              class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
              @click="toggleModal"
            >
              <font-awesome-icon icon="fa-smile" />
            </button>

            <div v-if="emojiModalFlag" class="absolute bottom-0 ml-32">
              <EmojiPicker
                v-if="emojiModalFlag"
                :toggleModal="toggleModal"
                :addReaction="addReaction"
              />
            </div>

            <button
              v-if="!editMessage"
              class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
            >
              <font-awesome-icon icon="fa-at" />
            </button>
            <button
              class="px-2 py-1 hover:bg-transparent rounded italic focus:outline-none"
              @click="toggleTopBar"
            >
              <font-awesome-icon :icon="toggleIcon" />
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
    <div v-if="!isConnected" class="px-3 flex gap-1 text-black-600">
      <div class="cross">
        <font-awesome-icon icon="fa-wifi" class="" />
      </div>
      {{ $t('connection.trying_to_connect') }}
    </div>
  </div>
</template>

<script>
import { ref, watch, onMounted } from 'vue';
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
import Mention from '@tiptap/extension-mention';
import suggestion from './suggestion';
import { CONSTANTS } from '../../../assets/constants';
import VoiceRecorder from './VoiceRecorder.vue';
import VisualizeVoice from './VisualizeVoice.vue';
import VideoRecord from '../../widgets/videoRecord.vue';
import VisualizeVideo from '../../widgets/VisualizeVideo.vue';
import EmojiPicker from '../../widgets/emojipicker.vue';
import { useConnectionStore } from '../../../stores/useConnectionStore.js';
import BulletList from '@tiptap/extension-bullet-list'
import ListItem from '@tiptap/extension-list-item'
import OrderedList from '@tiptap/extension-ordered-list'


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
  components: {
    Attachments,
    NMention,
    ScheduleModal,
    AttachmentShortCutVue,
    CreateTextSnippetModal,
    EditorContent,
    NDivider,
    VoiceRecorder,
    VisualizeVoice,
    VideoRecord,
    VisualizeVideo,
    EmojiPicker,
  },
  computed: {
    toggleIcon() {
      return this.showTopBar ? 'fa-toggle-off' : 'fa-toggle-on';
    },
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
    fromThreads: {
      type: Boolean,
    },
    conversationType: {
      type: String,
    },
    conversationId: {
      type: Number,
    },
    parentMessageId: {
      type: Number,
    },
    recieverName: {
      type: String,
    },
    repliedParentMessage: {
      type: String,
    },
  },
  methods: {
    createURL(file) {
      return URL.createObjectURL(file);
    },
    toggleTopBar() {
      this.showTopBar = !this.showTopBar;
    },

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
  },

  setup(props) {
    const channelStore = useChannelStore();
    const profileStore = useProfileStore();
    const searchStore = useSearchStore();
    const FilesStore = useRecentFilesStore();
    const connectionStore = useConnectionStore();
    const turndownService = new TurndownService();
    const { channels } = storeToRefs(channelStore);
    const { isConnected } = storeToRefs(connectionStore);
    const messageStore = useMessageStore();
    const { selectedChat, messageToEdit } = storeToRefs(messageStore);
    const { searches } = storeToRefs(searchStore);
    const scheduleModalFlag = ref(false);
    const { profiles } = storeToRefs(profileStore);
    const newMessage = ref('');
    const editorContent = ref('');
    const readerFile = ref([]);
    const audioFiles = ref([]);
    const files = ref([]);
    const videoFiles = ref([]);
    const filteredList = ref([]);
    const schedule = ref(null);
    const attachmentAndShortcutStore = useShortcutAndAttachmentStore();
    const editor = ref(null);
    const emojiModalFlag = ref(false);
    const showTopBar = ref(true);

    const CustomBulletList = BulletList.extend({
      defining: true,
      addKeyboardShortcuts() {
        return {
          'Shift-Enter': () => editor.value.chain().focus().splitListItem('listItem').run(),
        }
      },
    })

    onMounted(() => {
      editor.value = new Editor({
        extensions: [
          StarterKit,
          Mention.configure({
            HTMLAttributes: {
              class: 'mention',
            },
            suggestion,
          }),
          Placeholder.configure({
            placeholder: getPlaceholder,
          }),
          CustomBulletList.configure({
            itemTypeName: 'listItem',
            keepMarks: true,
            keepAttributes: true,
          }),
          OrderedList,
          ListItem,
        ],
        autofocus: 'end',
        onUpdate: () => {
          editorContent.value = editor.value.getHTML();
        },
        content: newMessage.value,
      });
      if (isEditScheduled()) {
        newMessage.value = props.messageToEdit.content;
      }
    });

    const addReaction = emoji => {
      editor.value.commands.insertContent(emoji.i);
      toggleModal();
    };

    const toggleModal = () => {
      emojiModalFlag.value = !emojiModalFlag.value;
    };

    const makeBlocks = async line => {
      const block = await markdownToBlocks(line);
      return block[0];
    };

    const formatBlockContent = array => {
      return array.map(item => {
        if (
          item.text &&
          item.text.type === 'mrkdwn' &&
          typeof item.text.text === 'string'
        ) {
          item.text.text = item.text.text.replace(/&quot;/g, `"`);
          item.text.text = item.text.text.replace(/&#39;/g, `'`);
          item.text.text = item.text.text.replace(/~/g, '~~');
        }
        return item;
      });
    };

    const sendMessagePayload = async (event, buttonClicked) => {
      if (
        ((event.keyCode === 13 && !event.shiftKey) || buttonClicked) &&
        !props.editMessage
      ) {
        const mrkdwn = [];
        const htmlList = editorContent.value.split('<br>');
        htmlList.forEach(async line => {
          turndownService.addRule('s', {
            filter: ['s'],
            replacement: function (content) {
              return '~~' + content + '~~';
            },
          });

          turndownService.addRule('', {
            filter: [`"`],
            replacement: function (content) {
              return `"` + content + `"`;
            },
          });

          mrkdwn.push(turndownService.turndown(line));
        });

        const result = await Promise.all(
          mrkdwn.map(async line => {
            line = line.replace(/\*\*/g, '****');
            return await makeBlocks(line);
          })
        );

        if (result[0] != null) {
          const output = formatBlockContent(result);
          props.fromThreads
            ? props.sendMessage(
                { blocks: output },
                files.value,
                props.conversationType,
                props.conversationId,
                props.parentMessageId
              )
            : props.sendMessage(
                { blocks: output },
                files.value,
                schedule.value
              );
          newMessage.value = '';
          readerFile.value = [];
          files.value = [];
          audioFiles.value = [];
          videoFiles.value = [];
          schedule.value = null;
          editor.value.commands.setContent([]);
        }
      }
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

    const isEditScheduled = () => {
      return (
        messageToEdit.content &&
        messageToEdit.isScheduled &&
        messageToEdit.scheduledId
      );
    };

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

    const removeFile = file => {
      const index = readerFile.value.indexOf(file);
      files.value.splice(index, 1);
      readerFile.value.splice(index, 1);
    };
    const removeAudioFile = file => {
      const index = audioFiles.value.indexOf(file);
      files.value.splice(index, 1);
      audioFiles.value.splice(index, 1);
    };
    const getImages = file => {
      files.value[files.value?.length] = file;
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => readerFile.value.push(reader.result);
    };
    const getAudio = file => {
      files.value[files.value?.length] = file;
      audioFiles.value.push(file);
    };
    const getVideoFiles = file => {
      files.value[files.value?.length] = file;
      videoFiles.value.push(file);
    };
    const removeVideoFiles = file => {
      const index = videoFiles.value.indexOf(file);
      files.value.splice(index, 1);
      videoFiles.value.splice(index, 1);
    };

    const getPlaceholder = () => {
      return props.isThread
        ? CONSTANTS.REPLY_PLACEHOLDER
        : `${CONSTANTS.MESSAGE} ${getRecipientName()}`;
    };

    const getRecipientName = () => {
      return (
        getChannelName() || selectedChat.username || CONSTANTS.EMPTY_PLACEHOLDER
      );
    };

    const getChannelName = () => {
      return selectedChat.value.name
        ? (selectedChat.value.is_private ? CONSTANTS.LOCK : CONSTANTS.HASH) +
            selectedChat.value.name
        : false;
    };

    const fileRecieverName = () => {
      return recieverName || getChannelName || selectedChat.value.username;
    };

    const setLink = () => {
      const previousUrl = editor.value.getAttributes('link').href;
      const url = window.prompt('URL', previousUrl);
      if (url === null) {
        return;
      }
      if (url === '') {
        editor.value.chain().focus().extendMarkRange('link').unsetLink().run();
        return;
      }
      editor.value
        .chain()
        .focus()
        .extendMarkRange('link')
        .setLink({ href: url })
        .run();
    };

    const toggleSchedule = () => {
      scheduleModalFlag.value = !scheduleModalFlag.value;
    };

    return {
      newMessage,
      readerFile,
      audioFiles,
      files,
      channels,
      profiles,
      isConnected,
      schedule,
      scheduleModalFlag,
      messageStore,
      emojiModalFlag,
      messageToEdit,
      removeFile,
      removeAudioFile,
      getImages,
      getAudio,
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
      editor,
      fileRecieverName,
      setLink,
      videoFiles,
      getVideoFiles,
      removeVideoFiles,
      formatBlockContent,
      sendMessagePayload,
      addReaction,
      toggleModal,
      showTopBar,
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
    padding: 0.5rem 1rem;
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

.mention {
  background-color: rgba(0, 110, 255, 0.124) !important;
  border-radius: 0.3rem;
  color: rgb(73, 145, 240);
  padding: 0.1rem 0.3rem;
  box-decoration-break: clone;
  cursor: pointer;
}

.cross {
  position: relative;
}

.cross::after {
  content: '';
  position: absolute;
  width: 100%;
  height: 2px;
  background-color: #6e6f73;
  left: 0;
  top: 50%;
  transform: rotate(-45deg);
}
</style>
