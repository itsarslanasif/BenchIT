<template>
  <div v-if="starChannels.length > 0" class="hover-trigger">
    <font-awesome-icon
      @click="goToChannels"
      icon="fa-plus"
      class="hover-target px-2 p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
    />
    <AccordionList class="mt-5 ml-4 text-base text-slate-50">
      <AccordionItem :default-opened="true">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer">
            {{ $t('channels.starred') }}
          </span>
        </template>
        <h5
          v-for="channel in starChannels"
          :key="channel.id"
          class="hover:bg-primaryHover"
        >
          <ChannelItem
            :channel="channel"
            :goTo="goToChannelChat"
            :toggleShow="toggleChannelOptionShow"
            :isShowOptions="showChannelOptions"
          />
        </h5>
      </AccordionItem>
    </AccordionList>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  components: { AccordionList, AccordionItem, ChannelItem },
  data() {
    return {
      channels: [],
      showChannelOptions: false,
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    const channelStore = useChannelStore();
    const { starChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    return {
      starChannels,
      leftPaneStore,
      messagesStore,
    };
  },
  methods: {
    goToChannelChat(chatURL, channel) {
      this.messagesStore.setSelectedChat(channel);
      this.$router.push(chatURL);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
    },
    isMobileView() {
      return window.innerWidth < 1400;
    },
    toggleChannelOptionShow() {
      this.showChannelOptions = !this.showChannelOptions;
    },
    goToChannels() {
      this.$router.push('/browse-channels');
    },
  },
};
</script>
<style scoped>
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
