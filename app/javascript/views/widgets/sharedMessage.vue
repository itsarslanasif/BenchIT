<template>
  <div
    class="group hover:bg-white hover:shadow-xs cursor-pointer rounded px-1 py-1 w-150 mt-1"
  >
      <div
        v-for="block in messageBlock.blocks"
        :key="block"
        class="flex"
        >
        <user-profile-modal
                    :profile_id="currMessage.sender_id"
                    :sender_avatar="currMessage.sender_avatar"
                />
      <MessageSection
      v-if="block.type === 'section'"
                :section="block"
      />
      </div>

  </div>
</template>

<script>
import moment from 'moment';
import UserProfileModal from '../widgets/UserProfileModal.vue';
import MessageSection from '../components/messages/MessageSection.vue'
import { NAvatar } from 'naive-ui';

export default {
  components: { NAvatar, UserProfileModal, MessageSection },
  props: {
    currMessage: Object,
    toggleThread: Function,
    isSameUser: Boolean,
    isSameDayMessage: Boolean,
    repliesCount: String,
    lastThreeRepliesOfUniqueUsers: Array,
    lastReply: Object,
    isFirstMessage: Boolean,
  },
  computed: {
     messageBlock() {
      return JSON.parse(this.currMessage.content);
    },
  },
  methods: {
    formatDate(date) {
      return moment(date).calendar();
    },
  },
};
</script>
