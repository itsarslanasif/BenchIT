<template>
  <Dummy />
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
          {{ item.creator_id ? item.name : item.username }}
        </div>
      </div>
    </div>
    <div>
      <div
        v-if="schedule"
        class="bg-slate-50 border-l border-t border-r border-slate-100 px-2 py-1 rounded-t"
      >
        {{ getScheduleNotification() }}
      </div>
      <editor
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
      />
    </div>
    <div>
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
    <div class="flex bg-transparent border border-black-300 w-full relative">
      <Attachments :getImages="getImages" />
      <div class="w-1/12 flex justify-end mr-12">
        <div v-if="editMessage" class="flex">
          <button
            @click="handleCancelEdit"
            class="px-2 my-4 rounded-md text-white"
          >
            <font-awesome-icon
              icon="fa-xmark"
              class="bg-danger mt-1 hover:bg-dangerHover px-3 py-2 rounded"
            />
          </button>
          <button
            @click="sendMessagePayload($event, true)"
            class="px-2 my-4 rounded-md text-white"
          >
            <font-awesome-icon
              icon="fa-check"
              class="bg-success mt-1 hover:bg-successHover px-3 py-2 rounded"
            />
          </button>
        </div>
        <div v-else>
          <div
            class="w-1/12 cursor-pointer ml-5 my-2 flex justify-center items-center text-white"
          >
            <font-awesome-icon
              icon="fa-paper-plane"
              class="bg-success hover:bg-successHover px-3 py-2 border-r rounded-l"
              @click="dispatchKeydownEnterEvent"
            />
            <font-awesome-icon
              v-if="!isThread"
              @click="toggleSchedule"
              icon="fa-solid fa-chevron-down"
              class="bg-success hover:bg-successHover p-2 rounded-r"
            />
          </div>
        </div>
        <div v-if="scheduleModalFlag">
          <ScheduleModal
            :setSchedule="setSchedule"
            :toggleSchedule="toggleSchedule"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch } from 'vue';
import Editor from '@tinymce/tinymce-vue';
import Dummy from './Dummy.vue'
import { markdownToBlocks } from '@tryfabric/mack'
import TurndownService from 'turndown'
import Attachments from '../attachments/Attachments.vue';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { NMention } from 'naive-ui';
import ScheduleModal from '../../widgets/schedule.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';
import moment from 'moment';
import vClickOutside from 'click-outside-vue3';
import AttachmentShortCutVue from './Attachment&shortCutModal.vue';
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
import CreateTextSnippetModal from './CreateTextSnippetModal.vue';

export default {
  beforeMount() {
    if (this.message) {
      this.newMessage = this.message;
    }
  },
  mounted() {
    if (this.isEditScheduled()) {
      this.newMessage = this.messageToEdit.content;
    }
  },
  components: {
    editor: Editor,
    Attachments,
    NMention,
    ScheduleModal,
    AttachmentShortCutVue,
    CreateTextSnippetModal,
    Dummy
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
  setup(props) {
    const channelStore = useChannelStore();
    const profileStore = useProfileStore();
    const FilesStore = useRecentFilesStore();
    const turndownService = new TurndownService()
    const { channels } = storeToRefs(channelStore);
    const messageStore = useMessageStore();
    const { selectedChat, messageToEdit } = storeToRefs(messageStore);
    const scheduleModalFlag = ref(false);
    const { profiles } = storeToRefs(profileStore);
    const newMessage = ref('');
    const showMentions = ref(false);
    const showChannels = ref(false);
    const hasMentionCommand = ref(false);
    const hasChannelCommand = ref(false);
    const readerFile = ref([]);
    const files = ref([]);
    const filteredList = ref([]);
    const schedule = ref(null);
    const attachmentAndShortcutStore = useShortcutAndAttachmentStore();

    watch(newMessage, (curr, old) => {
      const currentMessage = ignoreHTML(curr);
      const oldMessage = ignoreHTML(old);
      const message = ignoreHTML(newMessage.value);

      if (
        message &&
        getLastIndex(currentMessage) == '@' &&
        getLastIndex(oldMessage) == ';'
      ) {
        enableMention();
      } else if (
        message &&
        getLastIndex(currentMessage) == '#' &&
        getLastIndex(oldMessage) == ';'
      ) {
        enableChannels();
      } else if (message.length === 1 && getLastIndex(currentMessage) == '@') {
        enableMention();
      } else if (message.length === 1 && getLastIndex(currentMessage) == '#') {
        enableChannels();
      } else if (!message) {
        disableAll();
      } else {
        disableAll();
      }
    });

    const getLastIndex = value => {
      return value[value.length - 1];
    };
    const setSchedule = value => {
      schedule.value = value;
      toggleSchedule();
    };

    const makeBlocks = async (line) => {
      const block = await markdownToBlocks(line);
      return block[0];
    };

    const sendMessagePayload = async (event, buttonClicked) => {
      if (
        ((event.keyCode === 13 && !event.shiftKey) || buttonClicked) &&
        !props.editMessage
      ) {
        const startWithNonBreakSpace =
          newMessage.value.startsWith('<p>&nbsp;</p>');
        const messagetext = message(newMessage);
        if (
          messagetext !== '' &&
          messagetext !== '<p> </p>' &&
          !startWithNonBreakSpace
        ) {
          const mrkdwn = []
          const htmlList = messagetext.split('<br />');
          htmlList.forEach(async line => {
            mrkdwn.push(turndownService.turndown(line))
          });
          const result = await Promise.all(mrkdwn.map(async line => {
            return await makeBlocks(line)
          }));
          props.sendMessage({ blocks: result }, files.value, schedule);
          newMessage.value = '';
          readerFile.value = [];
          files.value = [];
          schedule.value = null;
        }
      } else if (
        ((event.keyCode === 13 && !event.shiftKey) || buttonClicked) &&
        props.editMessage
      ) {
        props.editMessageCallBack(newMessage.value);
        messageStore.removeMessageToEdit();
      }
    };

    const dispatchKeydownEnterEvent = () => {
      const event = new KeyboardEvent('keydown', { keyCode: 13 });
      if (isEditScheduled()) {
        messageStore.reEditScheduledMessage({
          content: newMessage,
          id: messageToEdit.scheduledId,
        });
        newMessage = '';
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

    const enableMention = () => {
      filteredList.value = profiles.value;
      hasMentionCommand.value = true;
      showMentions.value = true;
      hasChannelCommand.value = false;
      showChannels.value = false;
    };

    const enableChannels = () => {
      filteredList.value = channels.value;
      hasChannelCommand.value = true;
      showChannels.value = true;
      hasMentionCommand.value = false;
      showMentions.value = false;
    };

    const disableAll = () => {
      hasMentionCommand.value = false;
      showMentions.value = false;
      hasChannelCommand.value = false;
      showChannels.value = false;
    };

    const addMentionToText = e => {
      newMessage.value = `${newMessage.value.slice(0, -4)}<span>${
        e.target.outerText
      }</span> ${newMessage.value.slice(-4)}`;
      showMentions.value = false;
      hasMentionCommand.value = false;
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
      sendMessagePayload,
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
    };
  },
};
</script>
<style scoped>
.margintop {
  margin-top: -270px;
}
</style>
