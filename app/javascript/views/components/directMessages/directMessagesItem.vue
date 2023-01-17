<template>
  <div v-if="sortedDMList">
    <h5
      v-for="user in sortedDMList"
      :key="user"
      class="hover:bg-primaryHover"
    >
      <div
        v-if="user"
        @click="goToChat(`/profiles/${user.id}`, user)"
        class="flex items-center -ml-4 py-1 px-5 cursor-pointer hover:bg-primaryHover"
        :class="isUnreadDM(user) ? 'font-bold' : ''"
      >
        <n-avatar :size="25" :src="user.image_url" />
        <p class="ml-2 text-sm text-white">{{ user.username }}</p>
        <p v-if="isOwnChat(user)" class="ml-2 text-sm text-black-400">
          {{ $t('pinconversation.you') }}
        </p>
        <n-tooltip trigger="hover">
          <template #trigger>
            <p class="ml-2 text-sm self-center text-white">
              {{ user.status.emoji }}
            </p>
          </template>
          <span> {{ user.status?.text }} </span>
        </n-tooltip>
        <div
          v-if="unreadDetails?.messages.length"
          class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2"
        >
          {{ unreadDetails.messages.length }}
        </div>
      </div>
    </h5>
  </div>
</template>
<script>
import { useUnreadStore } from '../../../stores/useUnreadStore';
import { storeToRefs } from 'pinia';
import { unreadMessagesCount } from '../../../modules/unreadMessages';
import { NAvatar, NTooltip } from 'naive-ui';

export default {
  components: { NAvatar, NTooltip },
  props: ['sortedDMList', 'isOwnChat', 'goToChat'],
  data() {
    return {
      unreadMessagesCount: 0,
      unreadDetails: null,
    };
  },
  setup() {
    const unreadStore = useUnreadStore();
    const { unreadMessages } = storeToRefs(unreadStore);
    return {
      unreadMessages,
    };
  },
  methods: {
    isUnreadDM(user) {
      this.unreadDetails = unreadMessagesCount(
        this.unreadMessages,
        `Profile${user.id}`
      );
      return this.unreadDetails?.messages.length;
    },
  },
};
</script>
