<template>
  <n-dropdown class="rounded-md" placement="bottom-end" size="medium" :show="showChannelOptions"
    :options="channel_options" @mouseleave="toggleChannelOptionShow" @select="handleSelect($event)"
    :on-clickoutside="toggleChannelOptionShow">
    <div oncontextmenu="return false;" class="flex items-center pl-3 py-1 hover:bg-primaryHover cursor-pointer" @click="goTo(`/channels/${channel.id}`, this.channel)"
      @click.right="toggleChannelOptionShow">
      <div class="w-5">
        <div v-if="channel.is_private">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else>
          <font-awesome-icon icon="fa-hashtag" />
        </div>
      </div>
      <div class="px-2 truncate" :class="isUnreadChannel(channel) ? 'font-bold' : ''">
        {{ channel.name }}
      </div>
      <div v-if="unreadDetails?.messages.length" class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2">
        {{ totalUnreadMessages(unreadDetails) }}
      </div>
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown } from 'naive-ui';
import Option from './channel_options.js';
import { useChannelStore } from '../../../stores/useChannelStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import { storeToRefs } from 'pinia';
import { markStar } from '../../../modules/starunstar/starunstar.js';
import { unreadMessagesCount, unreadMessagesLength } from '../../../modules/unreadMessages';
import { useUnreadStore } from '../../../stores/useUnreadStore';
export default {
  components: { NDropdown, markStar },
  props: ['goTo', 'toggleShow', 'isShowOptions', 'channel'],
  setup() {
    const channelStore = useChannelStore();
    const unreadStore = useUnreadStore();
    const rightPaneStore = useRightPaneStore();
    const { unreadMessages } = storeToRefs(unreadStore);
    return { channelStore, unreadMessages, rightPaneStore };
  },
  data() {
    return {
      channel_options: [],
      currentChannel: {},
      showChannelOptions: false,
      unread: [],
      unreadDetails: null,
    };
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'star-channel':
          markStar(this.currentChannel, this.channelStore);
          break;
        case 'open-in-split-view':
          this.rightPaneStore.toggleViewSplitShow(true);
          this.rightPaneStore.setRightPaneSelectedChat(this.channel, 'channels')
          break;
        case 'unstar-channel':
          markStar(this.currentChannel, this.channelStore);
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
    setCurrentChannel() {
      this.currentChannel = this.channelStore.joinedChannels.find(obj => obj.id === Number(this.channel.id)) || this.channelStore.starChannels.find(obj => obj.id === Number(this.channel.id));
      this.channelStore.setCurrentChannel(this.currentChannel);
      this.channel_options = new Option(this.checkCurrentChannel(this.currentChannel)).getOptions();
    },
    toggleChannelOptionShow() {
      this.showChannelOptions = !this.showChannelOptions
      if (this.showChannelOptions) {
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
  },
};
</script>
