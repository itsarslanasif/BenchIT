<template>
  <div class="my-5 ml-3 text-base text-slate-50">
    <div class="mb-3" v-if="channels.starChannels.length">
      <ChannelList :channels="channels.starChannels" :heading="$t('channels.starred')" />
    </div>
    <ChannelList :channels="channels.joinedChannels" :heading="$t('channels.title')" />
    <div class="mt-2 -ml-3 cursor-pointer hover:bg-primaryHover" @click="closeModal">
      <h5 class="pl-3">{{ $t('channels.add_new_channel') }}</h5>
    </div>
    <div v-if="modalOpen">
      <CreateChannel :close-modal="closeModal" />
    </div>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import CreateChannel from './CreateChannel.vue';
import ChannelList from './ChannelList.vue';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  components: { AccordionList, AccordionItem, CreateChannel, ChannelItem, ChannelList },
  data() {
    return {
      modalOpen: false,
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    const channelStore = useChannelStore();
    const { channels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    return {
      channels: channels._object, messagesStore
    };
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
  },
};
</script>
