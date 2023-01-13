<template>
  <n-dropdown class="rounded-md" placement="bottom-end" size="medium" :show="showChannelOptions"
    :options="channel_options" @mouseleave="toggleChannelOptionShow" @select="handleSelect($event)"
    :on-clickoutside="toggleChannelOptionShow">
    <div oncontextmenu="return false;" @click="goTo(`/channels/${channel.id}`, this.channel)"
      @click.right="toggleChannelOptionShow" class="flex items-center -ml-4 pl-3 hover:bg-primaryHover cursor-pointer">
      <div class="w-5">
        <div v-if="channel.is_private">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else>
          <font-awesome-icon icon="fa-hashtag" />
        </div>
      </div>
      <div class="px-1">{{ channel.name }}</div>
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown } from 'naive-ui';
import Option from './channel_options.js';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { markStar } from '../../../modules/starunstar/starunstar.js';
export default {
  components: { NDropdown, markStar },
  props: ['goTo', 'toggleShow', 'isShowOptions', 'channel'],
  setup() {
    const channelStore = useChannelStore();
    return { channelStore, };
  },
  data() {
    return {
      channel_options: [],
      currentChannel: {},
      showChannelOptions: false,
    };
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
      }
    },
    checkCurrentChannel(channel) {
      if (channel.favourite_id) {
        return true;
      }
      else {
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
  },
};
</script>
