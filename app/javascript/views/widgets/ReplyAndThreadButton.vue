<template>
  <div
    @click="toggleThread"
    :class="{ 'ml-12': isSameUser && isSameDayMessage && !isFirstMessage && currMessage.content !== $t('deleteMessageModal.success') }"
    class="group hover:bg-white hover:shadow-xs cursor-pointer rounded px-1 py-1 w-150 mt-1"
  >
    <span
      v-for="reply in lastThreeRepliesOfUniqueUsers"
      class="mr-1"
      :key="reply.id"
    >
      <n-avatar size="small" class="align-middle" :src="reply.sender_avatar" />
    </span>
    <span
      class="text-info text-xs font-semibold self-center hover:underline mr-2"
    >
      {{ repliesCount }}
    </span>
    <span
      v-if="currMessage.replies.length > 1"
      class="visible group-hover:invisible text-xs text-black-600 self-center mr-1"
    >
      {{ $t('chat.last_reply') }}
    </span>
    <span
      class="visible group-hover:invisible text-xs text-black-600 self-center"
    >
      {{ formatDate(lastReply.created_at) }}
    </span>
    <span
      class="invisible group-hover:visible text-xs text-black-600 self-center mr-1"
    >
      {{ $t('chat.view_thread') }}
    </span>
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';

export default {
  components: { NAvatar },
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
  methods: {
    formatDate(date) {
      return moment(date).calendar();
    },
  },
};
</script>
