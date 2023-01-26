<template>
  <div
    v-if="user"
    @mouseleave="changeActive"
    @click="goToChat(`/profiles/${user.id}`, user)"
    class="flex items-center pl-2 py-1 hover:bg-primaryHover cursor-pointer"
    :class="isUnreadDM(user) ? 'font-bold' : ''"
  >
    <n-avatar :size="25" :src="user.image_url" />
    <div class="flex h-3 w-3 z-10">
      <div
        v-if="user.is_active"
        class="bg-green-700 awayStatus text-black-800 inactivePosition h-2 w-2 rounded-xl"
      />
      <div
        v-else
        class="bg-black-800 awayStatus text-black-800 inactivePosition h-2 w-2 border-2 border-white rounded-xl"
      />
    </div>
    <p class="ml-2 text-sm text-white truncate">{{ user.username }}</p>
    <p v-if="isOwnChat(user)" class="ml-2 text-sm text-black-400">
      {{ $t('pinconversation.you') }}
    </p>
    <n-tooltip trigger="hover">
      <template #trigger>
        <p class="ml-2 text-sm self-center text-white">
          {{ user?.status?.emoji }}
        </p>
      </template>
      <span>
        {{ user?.status?.text }}
        <span class="text-black-500">
          {{ $t('profilestatus.until') }}
        </span>
        {{ statusClearAfterTime(user?.status?.clear_after) }}
      </span>
    </n-tooltip>
    <div
      v-if="unreadDetails.messages.length"
      class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2"
    >
      {{ unreadDetails.messages.length }}
    </div>
  </div>
</template>
<script>
import { useUnreadStore } from '../../../stores/useUnreadStore';
import { storeToRefs } from 'pinia';
import { unreadMessagesCount } from '../../../modules/unreadMessages';
import { NAvatar, NTooltip } from 'naive-ui';
import moment from 'moment';

export default {
  components: { NAvatar },
  props: ['user', 'isOwnChat', 'goToChat'],
  components: { NAvatar, NTooltip },
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
  computed: {
    profileActiveStatus() {
      return true;
    },
  },
  methods: {
    isUnreadDM(user) {
      this.unreadDetails = unreadMessagesCount(
        this.unreadMessages,
        `Profile${user.id}`
      );
      return this.unreadDetails?.messages.length;
    },
    statusClearAfterTime(time) {
      return time ? moment(time).calendar() : moment().endOf('month').fromNow();
    },
    changeActive() {
      console.log('actice', this.user.is_active);
    },
  },
};
</script>
<style>
.awayStatus {
  margin-left: -5px;
  margin-top: 10px;
  font-size: 6px;
  outline: 3px solid rgb(31, 41, 55);
}
</style>
