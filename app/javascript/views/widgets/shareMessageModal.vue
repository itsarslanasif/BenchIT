<template>
  <n-modal
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
        :placeholder="$t('chat.share_title')"
        :options="options"
      />
    </template>
    <template #header v-else>
      <div class="border rounded p-2 bg-yellow-50 border-yellow-500">
        <p class="text-sm">
          {{ $t('chat.share_private_chat_note') }}
        </p>
      </div>
    </template>

    <TextEditorVue
      :sendMessage="sendMessage"
      :editMessage="false"
      :isThread="false"
      :repliedParentMessage="this.message"
    />

    <div class="flex mt-3 flex-center">
      <SharedMessage :currMessage="message" :inThread="false" />
    </div>
  </n-modal>
</template>

<script>
import { useUserProfileStore } from '../../stores/useUserProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import TextEditorVue from '.././components/editor/TextEditor.vue';
import { NSelect, NModal } from 'naive-ui';
import { conversation } from '../../../javascript/modules/axios/editorapi';
import { useChannelStore } from '../../stores/useChannelStore';
import SharedMessage from './sharedMessage.vue';

export default {
  setup() {
    const userProfileStore = useUserProfileStore();
    const profilesStore = useProfileStore();

    return {
      userProfileStore,
      profilesStore,
    };
  },
  props: ['message', 'toggleModal'],

  components: {
    NModal,
    NSelect,
    TextEditorVue,
    SharedMessage,
  },

  data() {
    return {
      options: [],
      selectedChannelID: '',
    };
  },

  computed: {
    checkConversationType() {
      return this.message.conversationable_type === 'BenchChannel';
    },
  },

  mounted() {
    this.options = this.setValue(
      useChannelStore().channels.map(record => ({
        value: `channels ${record.id}`,
        label: record.is_private
          ? this.$t('chat.lock') + record.name
          : this.$t('chat.hash') + record.name,
      })),
      useProfileStore().profiles.map(record => ({
        value: `profiles ${record.id}`,
        label: record.username,
      }))
    );
  },

  methods: {
    separateString(str) {
      let conversation_id = str.match(/\d+/g).map(Number);
      let conversation_type = str.match(/[a-zA-Z]+/g).join('');

      return { conversation_id, conversation_type };
    },

    setValue(id, type) {
      return [...id, ...type];
    },

    parentMessage() {
      return this.message.content;
    },

    sendMessage(message, files, schedule) {
      let conversation_info = {};

      if (this.selectedChannelID === '') {
        conversation_info = {
          conversation_id: [window.location.pathname.split('/')[2]],
          conversation_type: 'profiles',
        };
      } else {
        conversation_info = this.separateString(this.selectedChannelID);
      }
      let formData = new FormData();
      formData.append('content', JSON.stringify(message));
      formData.append('is_threaded', false);
      formData.append('shared_message_id', this.message.id);
      formData.append('conversation_type', conversation_info.conversation_type);
      formData.append(
        'conversation_id',
        parseInt(conversation_info.conversation_id[0])
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
        this.$router.push(
          `/${conversation_info.conversation_type}/${conversation_info.conversation_id[0]}`
        );
      });
      this.newMessageSent = true;
      this.toggleModal();
    },
  },
};
</script>
