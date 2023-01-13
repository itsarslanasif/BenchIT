<template>
  <n-dropdown
    class="rounded-md"
    placement="bottom-end"
    size="medium"
    :show="isShowOptions"
    :options="channel_options"
    @mouseleave="toggleShow"
    :on-clickoutside="toggleShow"
  >
    <div
      oncontextmenu="return false;"
      @click="goTo(`/channels/${channel.id}`, channel)"
      @click.right="toggleShow"
      class="flex items-center -ml-4 py-1 px-5 cursor-pointer hover:bg-primaryHover"
    >
      <div class="w-5 pl-1">
        <div v-if="channel.is_private">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else>
          <font-awesome-icon icon="fa-hashtag" />
        </div>
      </div>
      <div class="px-2" :class="isUnreadChannel(channel) ? 'font-bold' : ''">
        {{ channel.name }}
      </div>
      <div
        v-if="unreadDetails?.messages.length"
        class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2"
      >
        {{ unreadDetails.messages.length }}
      </div>
    </div>
  </n-dropdown>
</template>

<script>
import channel_options from './channel_options.js';
import { NDropdown } from 'naive-ui';
import { useUnreadStore } from '../../../stores/useUnreadStore';
import { storeToRefs } from 'pinia';
import { unreadMessagesCount } from '../../../modules/unreadMessages';

export default {
  name: 'ChannelItem',
  components: { NDropdown },
  props: ['goTo', 'toggleShow', 'isShowOptions', 'channel'],
  data() {
    return {
      channel_options: channel_options,
      unread: [],
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
    isUnreadChannel(channel) {
      this.unreadDetails = unreadMessagesCount(
        this.unreadMessages,
        `BenchChannel${channel?.id}`
      );
      return this.unreadDetails?.messages.length;
    },
  },
};
</script>
