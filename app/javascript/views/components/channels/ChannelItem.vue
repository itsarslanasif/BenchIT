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
      @contextmenu.prevent
      class="flex items-center rounded-md pl-3 py-1 hover:bg-primaryHover cursor-pointer duration-200"
      :class="channelItemStyles(channel)"
      @click="goTo(`/channels/${channel.id}`, this.channel)"
      @click.right="toggleRightClickMenu"
    >
      <div class="w-5">
        <div v-if="channel.is_private">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else>
          <font-awesome-icon icon="fa-hashtag" />
        </div>
      </div>
      <div
        class="px-2 truncate"
        :class="
          isChatOpen || isUnreadChannel(channel)
            ? 'text-white'
            : 'text-black-400'
        "
      >
        {{ channel.name }}
      </div>
      <div
        v-if="unreadDetails?.messages.length"
        class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2"
      >
        {{ totalUnreadMessages(unreadDetails) }}
      </div>
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown } from 'naive-ui';
import Option from './rightClickMenuOptions.js';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { markStar } from '../../../modules/starunstar/starunstar.js';
import {
  unreadMessagesCount,
  unreadMessagesLength,
} from '../../../modules/unreadMessages';
import { useUnreadStore } from '../../../stores/useUnreadStore';
import { useMessageStore } from '../../../stores/useMessagesStore.js';
export default {
  components: { NDropdown, markStar },
  props: ['goTo', 'toggleShow', 'isShowOptions', 'channel'],
  setup() {
    const channelStore = useChannelStore();
    const unreadStore = useUnreadStore();
    const { unreadMessages } = storeToRefs(unreadStore);
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { channelStore, unreadMessages, unreadStore, selectedChat };
  },
  data() {
    return {
      rightClickMenuOptions: [],
      currentChannel: {},
      showRightClickMenu: false,
      unread: [],
      unreadDetails: null,
    };
  },
  computed: {
    unReadMessageExist() {
      return this.unreadDetails?.messages.length > 0;
    },
    isChatOpen() {
      return (
        this.selectedChat.id === this.channel.id &&
        this.selectedChat.conversation_type === 'Channel' &&
        this.channel.conversation_type === 'BenchChannel'
      );
    },
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'star-channel':
          markStar(this.currentChannel, this.channelStore);
          break;
        case 'unstar-channel':
          markStar(this.currentChannel, this.channelStore);
          break;
        case 'mark-as-read':
          this.unreadStore.markedChatAsRead('channels', this.channel.id);
          break;
        case 'mute-channel':
          this.channelStore.muteUnmuteChannel(this.channel.id);
          break;
        case 'unmute-channel':
          this.channelStore.muteUnmuteChannel(this.channel.id);
          break;
      }
    },

    checkCurrentChannel(channel) {
      if (channel.favourite_id) {
        return true;
      } else {
        return false;
      }
    },

    setRightClickMenuOptions() {
      this.rightClickMenuOptions = new Option(
        this.checkCurrentChannel(this.currentChannel),
        this.unReadMessageExist,
        true,
        this.currentChannel.is_muted
      ).getOptions();
    },

    setCurrentChannel() {
      this.currentChannel =
        this.channelStore.joinedChannels.find(
          obj => obj.id === this.channel.id
        ) ||
        this.channelStore.starChannels.find(obj => obj.id === this.channel.id);
      this.channelStore.setCurrentChannel(this.currentChannel);
      this.setRightClickMenuOptions();
    },

    toggleRightClickMenu() {
      this.showRightClickMenu = !this.showRightClickMenu;
      if (this.showRightClickMenu) {
        this.setCurrentChannel();
      }
    },

    isUnreadChannel(channel) {
      this.unreadDetails = unreadMessagesCount(
        this.unreadMessages,
        `BenchChannel${channel?.id}`
      );
      return this.unreadDetails?.messages.length;
    },

    totalUnreadMessages(unreadDetails) {
      return unreadMessagesLength(unreadDetails);
    },

    channelItemStyles(channel) {
      if (this.isUnreadChannel(channel)) {
        return 'font-semibold text-white';
      }
      if (this.isChatOpen) {
        return 'bg-secondary text-white opacity-50';
      }
      if (channel.is_muted) {
        return 'opacity-50';
      }
    },
  },
};
</script>
