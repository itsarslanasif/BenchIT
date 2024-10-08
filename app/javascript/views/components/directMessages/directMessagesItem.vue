<template>
  <n-dropdown
    placement="bottom-end"
    size="medium"
    :show="showRightClickMenu"
    :options="rightClickMenuOptions"
    @mouseleave="toggleRightClickMenu"
    @select="handleSelect($event)"
    :on-clickoutside="toggleRightClickMenu"
  >
    <div
      v-if="user"
      class="flex items-center rounded-md hover-trigger-x justify-between pl-3 py-1 hover:bg-primaryHover cursor-pointer duration-200"
      :class="{
        'bg-secondary': isChatOpen,
        'font-semibold text-white': isUnreadDM(user),
      }"
      @click.right="toggleRightClickMenu"
      @contextmenu.prevent
    >
      <span
        @click="goToChat(`/profiles/${user.id}`, user)"
        class="flex item-center w-full rounded-md"
      >
        <n-avatar :size="25" :src="user.image_url" />
        <span class="flex z-10 items-end -ml-1">
          <span
            v-if="user.is_active"
            class="bg-green-700 border-white border rounded-full h-2 w-2"
          />
          <span
            v-else
            class="bg-black-900 border-white border rounded-full h-2 w-2"
          />
        </span>
        <p
          class="ml-2 text-sm truncate"
          :class="
            isChatOpen || isUnreadDM(user) ? 'text-white' : 'text-black-400'
          "
        >
          {{ user.username }}
        </p>
        <p v-if="isOwnChat(user)" class="ml-2 text-sm text-black-400">
          {{ $t('pinconversation.you') }}
        </p>
        <n-tooltip trigger="hover">
          <template #trigger>
            <p class="ml-2 text-sm self-center text-black-400">
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
      </span>
      <span class="flex">
        <div v-if="unreadDetails">
          <div
            v-if="unreadDetails.messages.length"
            class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2"
          >
            {{ totalUnreadMessages(unreadDetails) }}
          </div>
        </div>
        <div
          @click="removeChatFromList"
          class="hover-target-x px-2 py-auto rounded-full text-xs ml-auto mr-2"
        >
          <i class="fas fa-xmark" />
        </div>
      </span>
    </div>
  </n-dropdown>
</template>
<script>
import { useUnreadStore } from '../../../stores/useUnreadStore';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore';
import { storeToRefs } from 'pinia';
import {
  unreadMessagesCount,
  unreadMessagesLength,
} from '../../../modules/unreadMessages';
import { NAvatar, NTooltip } from 'naive-ui';
import moment from 'moment';
import { NDropdown } from 'naive-ui';
import Options from '../channels/rightClickMenuOptions';
import { useMessageStore } from '../../../stores/useMessagesStore';

export default {
  props: ['user', 'isOwnChat', 'goToChat'],
  components: { NAvatar, NTooltip, NDropdown },
  data() {
    return {
      unreadMessagesCount: 0,
      unreadDetails: null,
      showRightClickMenu: false,
      rightClickMenuOptions: [],
    };
  },
  setup() {
    const unreadStore = useUnreadStore();
    const directMessagesStore = useDirectMessagesStore();
    const messagesStore = useMessageStore();
    const { unreadMessages } = storeToRefs(unreadStore);
    const { selectedChat } = storeToRefs(messagesStore);
    return {
      unreadMessages,
      directMessagesStore,
      unreadStore,
      selectedChat,
    };
  },
  computed: {
    unReadMessageExist() {
      return this.unreadDetails?.messages.length > 0;
    },
    isChatOpen() {
      return (
        this.selectedChat.id === this.user.id &&
        this.selectedChat.hasOwnProperty('user_id') &&
        this.user.hasOwnProperty('user_id')
      );
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
    totalUnreadMessages(unreadDetails) {
      return unreadMessagesLength(unreadDetails);
    },
    async removeChatFromList() {
      await this.directMessagesStore.removeChatFromList(this.user.id);
    },
    handleSelect(key) {
      switch (key) {
        case 'mark-as-read':
          this.unreadStore.markedChatAsRead(
            this.$t('conversations.profiles'),
            this.user.id
          );
          break;
        default:
          break;
      }
    },
    setRightClickMenuOptions() {
      this.rightClickMenuOptions = new Options(
        false,
        this.unReadMessageExist,
        false
      ).getOptions();
    },
    toggleRightClickMenu() {
      this.showRightClickMenu = !this.showRightClickMenu;
      if (this.showRightClickMenu) {
        this.setRightClickMenuOptions();
      }
    },
  },
};
</script>
<style lang="scss">
.awayStatus {
  margin-left: -5px;
  margin-top: 10px;
  font-size: 6px;
  outline: 3px solid rgb(31, 41, 55);
}

.hover-trigger-x .hover-target-x {
  display: none;
}

.hover-trigger-x:hover .hover-target-x {
  display: inline;
  cursor: pointer;
}
</style>
