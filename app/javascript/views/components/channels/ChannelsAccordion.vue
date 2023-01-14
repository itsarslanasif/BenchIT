<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>{{ $t('channels.title') }}</template>
        <h5
          v-for="channel in joinedChannels"
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
        <div
          class="mt-2 -ml-4 cursor-pointer hover:bg-primaryHover flex"
          @click="closeModal"
        >
          <font-awesome-icon
            icon="fa-solid fa-plus"
            class="ml-2 bg-slate-700 p-1 border border-slate-700 rounded text-xs items-center mt-px"
          />
          <h5 class="pl-2">{{ $t('channels.add_new_channel') }}</h5>
        </div>
      </AccordionItem>
    </AccordionList>
    <div v-if="modalOpen">
      <CreateChannel :close-modal="closeModal" />
    </div>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import CreateChannel from './CreateChannel.vue';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  components: { AccordionList, AccordionItem, CreateChannel, ChannelItem },
  data() {
    return {
      channels: [],
      modalOpen: false,
      showChannelOptions: false,
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    return {
      joinedChannels,
      leftPaneStore,
      messagesStore,
    };
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
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
  },
};
</script>
