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
          class="mt-2 -ml-3 cursor-pointer hover:bg-primaryHover"
          @click="closeModal"
        >
          <h5 class="pl-3">{{ $t('channels.add_new_channel') }}</h5>
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
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    return {
      joinedChannels,
    };
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    goToChannelChat(chatURL) {
      this.$router.push(chatURL);
    },
    toggleChannelOptionShow() {
      this.showChannelOptions = !this.showChannelOptions;
    },
  },
};
</script>
