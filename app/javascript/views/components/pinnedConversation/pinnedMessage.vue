<template>
  <div
    class="p-1 cursor-pointer w-11/12 items-center text-black-800 text-xs flex relative"
    @click="jumpToConversation"
  >
    <font-awesome-icon class="p-1" icon="fa-solid fa-thumbtack" />
    {{ $t('pinconversation.pinned_by') }}
    {{ currMessage.pin.pinned_by }}
  </div>
  <div class="p-px px-4 relative mt-2">
    <div class="flex">
      <n-avatar
        @click="showUserProfile"
        class="mr-2 cursor-pointer"
        size="small"
        :src="currMessage.sender_avatar"
      />
      <span class="text-black-800 m-0">
        <p
          @click="showUserProfile"
          class="text-lg hover:underline cursor-pointer"
        >
          <b>{{ currMessage.sender_name }}</b>
        </p>
      </span>
    </div>
    <div class="mt-3">
      <span class="text-black-900 text-base" v-html="currMessage.content" />
      <div v-if="currMessage.attachments">
        <div v-for="attachment in currMessage.attachments" :key="attachment.id">
          <div
            class="flex gap-2 mt-2 border rounded-xl border-black-400 p-4 cursor-pointer"
            @click="openInNewTab(attachment.attachment_link)"
          >
            <img
              :src="attachment.attachment_link"
              class="rounded-md border-black-400 border object-cover h-12 w-12"
            />
            <div class="ml-2 flex flex-col">
              <span class="font-semibold text-base text-black-800">{{
                attachment.attachment.filename
              }}</span>
              <span class="text-black-600">{{
                attachment.attachment.content_type
              }}</span>
            </div>
          </div>
        </div>
      </div>
      <p class="text-sm mt-3 text-black-600 hover:underline cursor-pointer">
        {{ formatDate(currMessage.created_at) }}
      </p>
    </div>
  </div>
</template>

<script>
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import { useThreadStore } from '../../../stores/useThreadStore';
import { NAvatar } from 'naive-ui';
import moment from 'moment';
export default {
  setup() {
    const rightPaneStore = useRightPaneStore();
    const userProfileStore = useUserProfileStore();
    const profilesStore = useProfileStore();
    const threadStore = useThreadStore();
    const pinnedConversationStore = usePinnedConversation();
    const messageStore = useMessageStore();
    return {
      rightPaneStore,
      userProfileStore,
      profilesStore,
      pinnedConversationStore,
      threadStore,
      messageStore,
    };
  },
  props: ['currMessage'],
  components: {
    NAvatar,
  },
  methods: {
    formatDate(date) {
      return moment(date).calendar();
    },

    showUserProfile() {
      this.pinnedConversationStore.showAlert = false;
      this.pinnedConversationStore.closeModal();
      this.setUserProfileForPane();
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    setUserProfileForPane() {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === this.currMessage.sender_id
      );
      this.userProfileStore.setUserProfile(profile);
    },

    getConversationId() {
      return window.location.pathname.split('/')[2];
    },
    toggleThread() {
      this.threadStore.setMessage(this.currMessage);
      this.rightPaneStore.toggleThreadShow(true);
    },
    jumpToConversation() {
      this.pinnedConversationStore.showAlert = false;
      if (this.currMessage.conversationable_type == 'BenchChannel') {
        this.checkForThreadedMessage(this.currMessage);
        this.$router.push(
          `/channels/${this.getConversationId()}/${this.currMessage.id}`
        );
      } else if (this.currMessage.conversationable_type == 'Profile') {
        this.checkForThreadedMessage(this.currMessage);
        this.$router.push(
          `/profiles/${this.getConversationId()}/${this.currMessage.id}`
        );
      } else if (message.conversationable_type == 'Group') {
        this.$router.push(
          `/groups/${this.getConversationId()}/${this.currMessage.id}`
        );
      }
    },
    checkForThreadedMessage(message) {
      if (message.parent_message_id) {
        if (this.rightPaneStore.showThread) {
          this.rightPaneStore.toggleThreadShow(false);
        }
        this.threadStore.setMessage(
          this.messageStore.getMessage(message.parent_message_id)
        );
        this.rightPaneStore.toggleThreadShow(true);
      }
    },
    openInNewTab(url) {
      window.open(url, '_blank', 'noreferrer');
    },
  },
};
</script>
