<template>
  <div
    class="group flex hover:bg-white hover:shadow-xs cursor-pointer rounded p-2 mt-1"
    :class="inThread ? 'w-100' : ''"
  >
    <div class="h-full w-1 bg-primary border rounded-lg mr-2"></div>
    <div>
      <div v-for="block in messageBlock.blocks" :key="block" class="flex">
        <user-profile-modal
          :profile_id="currMessage.sender_id"
          :sender_avatar="currMessage.sender_avatar"
        />
        <div class="flex flex-col ml-1">
          <span class="text-sm font-bold text-black-800">{{ senderName }}</span>
          <MessageSection
            class="w-flexible-2xl"
            v-if="block.type === 'section'"
            :section="block"
          />
        </div>
      </div>
      <div class="text-sm text-black-600">
        <span>{{ postedIn }}</span>
        <n-divider vertical />
        <span>{{ postedAt }}</span>
        <n-divider class="bg-red-500" vertical />
        <span @click="jumpToConversation" class="text-info">
          view conversation</span
        >
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import UserProfileModal from '../widgets/UserProfileModal.vue';
import MessageSection from '../components/messages/MessageSection.vue';
import { NAvatar, NDivider } from 'naive-ui';

export default {
  components: { NAvatar, UserProfileModal, MessageSection, NDivider },
  props: ['currMessage', 'inThread'],
  computed: {
    messageBlock() {
      return JSON.parse(this.currMessage.content);
    },
    senderName() {
      return this.currMessage.sender_name;
    },
    postedIn() {
      if (this.currMessage.channel_name) {
        return 'Posted in # ' + this.currMessage.channel_name;
      }
      return 'Direct Message';
    },
    postedAt() {
      return moment(this.currMessage.created_at).calendar();
    },
  },
  methods: {
    formatDate(date) {
      return moment(date).calendar();
    },
    getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    },
    jumpToConversation() {
      switch (this.currMessage.conversationable_type) {
        case 'BenchChannel':
          this.$router.push(
            `/channels/${this.currMessage.conversationable_id}/${this.currMessage.id}`
          );
          break;
        case 'Profile':
          this.$router.push(
            `/profiles/${this.currMessage.conversationable_id}/${this.currMessage.id}`
          );
          break;
        case 'Group':
          this.$router.push(
            `/groups/${this.currMessage.conversationable_id}/${this.currMessage.id}`
          );
          break;
      }
    },
  },
};
</script>
