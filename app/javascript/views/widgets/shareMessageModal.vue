<template>
  <n-modal
    v-model:show="showDeleteModal"
    class="custom-card rounded-lg w-160"
    preset="card"
    :bordered="false"
    size="huge"
    content-style="overflow-y: auto; overflow-x: hidden; max-height: 440px"
  >
    <template #header v-if="checkConversationType">
      <span class="text-2xl font-bold"> </span>
      <n-select
        v-model:value="selectedChannelID"
        filterable
        placeholder="Please select a song"
        :options="allChannels"
      />
    </template>
    <template #header v-else>
      <div class="border rounded p-2 bg-yellow-50 border-yellow-500">
        <p class="text-sm">
          This message is from a private conversation, so it can only be shared
          in this thread
        </p>
      </div>
    </template>

    <TextEditorVue
      :sendMessage="sendMessage"
      :editMessage="false"
      :isThread="false"
      :repliedParentMessage="this.message"
    />
  </n-modal>
</template>

<script>
import { useUserProfileStore } from '../../stores/useUserProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import TextEditorVue from '.././components/editor/TextEditor.vue';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import MessageSection from '../components/messages/MessageSection.vue';
import { NSelect, NButton, NInput } from 'naive-ui';
import { deleteMessage } from '../../api/messages';
import downloadsModal from '../widgets/downloadsModal/downloadsModal.vue';
import { NModal, NAvatar, NCollapse, NCollapseItem, NPopover } from 'naive-ui';
import { conversation } from '../../../javascript/modules/axios/editorapi';
import { fileDownload } from '../../api/downloads/downloads.js';
import { useDownloadsStore } from '../../stores/useDownloadsStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { useMessageStore } from '../../../javascript/stores/useMessagesStore';
import { ref } from 'vue';
import moment from 'moment';
import { storeToRefs } from 'pinia';

export default {
  setup() {
    const messagesStore = useMessageStore();
    const rightPaneStore = useRightPaneStore();
    const userProfileStore = useUserProfileStore();
    const profilesStore = useProfileStore();
    const downloadsStore = useDownloadsStore();
    const { selectedChat } = storeToRefs(messagesStore);

    return {
      overlap: ref(true),
      rightPaneStore,
      userProfileStore,
      selectedChat,
      profilesStore,
      downloadsStore,
    };
  },
  props: ['message', 'setDeleteModal'],
  components: {
    NModal,
    NButton,
    NAvatar,
    NCollapse,
    NCollapseItem,
    NPopover,
    downloadsModal,
    NSelect,
    TextEditorVue,
    MessageSection,
    NInput,
  },
  data() {
    return {
      showFileOptions: false,
      allChannels: [],
      selectedChannelID: '',
    };
  },
  computed: {
    time() {
      return moment(new Date(this.message.created_at).getTime()).format(
        'h:mm A'
      );
    },
    checkConversationType() {
      return this.message.conversationable_type === 'BenchChannel';
    },
  },
  mounted() {
    this.allChannels = this.setValue(
      useProfileStore().profiles.map(record => ({
        value: `profiles ${record.id}`,
        label: record.username,
      })),
      useChannelStore().channels.map(record => ({
        value: `channels ${record.id}`,
        label: record.name,
      }))
    );
  },
  methods: {
    showUserProfile() {
      this.setUserProfileForPane();
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    separateString(str) {
      let numbers = str.match(/\d+/g).map(Number);
      let letters = str.match(/[a-zA-Z]+/g).join('');

      return { numbers, letters };
    },

    onClick() {},

    setValue(id, type) {
      return [...id, ...type];
    },

    setUserProfileForPane() {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === this.message.sender_id
      );
      this.userProfileStore.setUserProfile(profile);
    },

    handleClick() {
      this.setDeleteModal();
      this.showUserProfile();
    },

    deleteMessage() {
      deleteMessage(this.message.id);
      this.setDeleteModal();
    },

    getTitle(message) {
      if (message.attachments.length > 1) {
        return `${message.attachments.length} files`;
      } else if (message.attachments.length === 1) {
        return message.attachments[0].attachment.filename;
      }
    },

    downloadFile(attachment) {
      try {
        fileDownload(attachment).then(response => {
          this.downloadsStore.downloads.unshift(response.data);
          this.downloadsStore.response = response;
          this.downloadsStore.downloadAlert = true;
        });
        this.downloadsStore.downloadAlert = false;
      } catch (error) {
        this.downloadsStore.downloadAlert = true;
      }
    },

    setFileOptionsModal() {
      this.showFileOptions = !this.showFileOptions;
    },

    getChannelNames() {
      //     this.allChannels = useChannelStore().channels.map(record => ({ value: record.id, name: record.name }));
      //    return this.allChannels
    },

    handleSelect() {
      this.selectedChannelId = event;
    },

    parentMessage() {
      return this.message.content;
    },

    sendMessage(message, files, schedule) {
      let conversation_type_and_id = {};

      if (this.selectedChannelID === '') {
        conversation_type_and_id = {
          numbers: [window.location.pathname.split('/')[2]],
          letters: 'profiles',
        };
      } else {
        conversation_type_and_id = this.separateString(this.selectedChannelID);
      }
      let formData = new FormData();
      formData.append('content', JSON.stringify(message));
      formData.append('is_threaded', false);
      formData.append('shared_message_id', this.message.id);
      formData.append('conversation_type', conversation_type_and_id.letters);
      formData.append(
        'conversation_id',
        parseInt(conversation_type_and_id.numbers[0])
      );
      if (schedule && schedule.value) {
        formData.append('scheduled_at', schedule.value);
      }
      files.forEach(file => {
        formData.append('message_attachments[]', file, message);
      });
      conversation(formData).then(res => {
        if (res.scheduled_at) {
          this.messageStore.addScheduleMessage(res);
        }
      });
      this.newMessageSent = true;
      this.setDeleteModal();
      this.$router.push(
        `/${conversation_type_and_id.letters}/${conversation_type_and_id.numbers[0]}`
      );
    },
  },
};
</script>
