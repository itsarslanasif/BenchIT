<template>
  <div
    class="p-1 cursor-pointer w-11/12 items-center text-black-800 text-xs flex relative"
    @click="jumpToConversation"
    v-if="currMessage.pin"
  >
    <font-awesome-icon class="p-1" icon="fa-solid fa-thumbtack" />
    {{ $t('pinconversation.pinned_by') }}
    {{ currMessage.pin.pinned_by }}
  </div>
  <div class="p-px px-4 relative mt-2">
    <div class="flex">
      <n-avatar
        @click="showUserProfile"
        class="mr-2 mt-1 cursor-pointer"
        :size="20"
        :src="currMessage.sender_avatar"
      />
      <span class="text-black-800">
        <p
          @click="showUserProfile"
          class="text-lg hover:underline cursor-pointer"
        >
          <b>{{ currMessage.sender_name }}</b>
        </p>
      </span>
    </div>
    <div class="mt-px">
      <span class="text-black-900 text-sm" v-html="currMessage.content" />
      <div v-if="currMessage.attachments">
        <div v-for="attachment in currMessage.attachments" :key="attachment.id">
          <div
            class="flex gap-2 mt-2 border rounded-xl border-black-300 p-3 cursor-zoomin"
            @click="openInNewTab(attachment.attachment_link)"
          >
            <img
              :src="attachment.attachment_link"
              class="rounded-md border-black-400 border object-cover h-12 w-12"
            />
            <div class="ml-2 flex flex-col">
              <span class="font-semibold text-sm text-black-800">
                {{ attachment.attachment.filename }}
              </span>
              <span class="text-black-600">
                {{ attachment.attachment.content_type }}
              </span>
            </div>
          </div>
        </div>
      </div>
      <p class="text-xs mt-3 text-black-600 hover:underline cursor-pointer">
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
    const targetMessage = null;
    return {
      rightPaneStore,
      userProfileStore,
      profilesStore,
      pinnedConversationStore,
      threadStore,
      messageStore,
      targetMessage
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

    getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    },

    toggleThread() {
      this.threadStore.setMessage(this.currMessage);
      this.rightPaneStore.toggleThreadShow(true);
    },

    jumpToConversation() {
      this.pinnedConversationStore.showAlert = false;
      switch (this.currMessage.conversationable_type) {
        case 'BenchChannel':
          this.checkForThreadedMessage(this.currMessage);
          this.$router.push(
            `/channels/${this.getIndexByParams(2)}/${this.currMessage.id}`
          );
          break;
        case 'Profile':
          this.checkForThreadedMessage(this.currMessage);
          this.$router.push(
            `/profiles/${this.getIndexByParams(2)}/${this.currMessage.id}`
          );
          break;
        case 'Group':
          this.checkForThreadedMessage(this.currMessage);
          this.$router.push(
            `/groups/${this.getIndexByParams(2)}/${this.currMessage.id}`
          );
          break;
      }
    },

    async loadMoreMessages() {
      await this.messageStore.index(this.getIndexByParams(1), this.getIndexByParams(2));
    },

    async findParentMessage(id) {
      this.targetMessage = this.messageStore.getMessage(id)
      if (!this.targetMessage) {
         await this.loadMoreMessages()
         await this.findParentMessage(id)
      }
    },

   async checkForThreadedMessage(message) {
      if (message.parent_message_id) {
        if (this.rightPaneStore.showThread) {
          this.rightPaneStore.toggleThreadShow(false);
        }
        await this.findParentMessage(message.parent_message_id)
        if (this.targetMessage) {
           this.threadStore.setMessage(this.targetMessage)
           this.rightPaneStore.toggleThreadShow(true);
        }
      }
    },

    openInNewTab(url) {
      window.open(url, '_blank', 'noreferrer');
    },
  },
};
</script>
