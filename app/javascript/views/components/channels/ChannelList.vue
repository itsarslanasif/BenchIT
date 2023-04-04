<template>
  <AccordionList>
    <AccordionItem default-opened="true">
      <template #summary>{{ heading }}</template>
      <h5
        v-for="channel in channels"
        :key="channel.id"
        class="hover:bg-primaryHover"
      >
        <ChannelItem :channel="channel" :goTo="goToChannelChat" />
      </h5>
    </AccordionItem>
  </AccordionList>
</template>

<script>
import ChannelItem from './ChannelItem.vue';
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import { useChannelStore } from '../../../stores/useChannelStore';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  components: {
    ChannelItem,
    AccordionItem,
    AccordionList,
  },
  setup() {
    const channelStore = useChannelStore();
    const leftPaneStore = useLeftpaneStore();
    const messagesStore = useMessageStore();
    return { channelStore, leftPaneStore, messagesStore };
  },
  props: ['channels', 'heading'],
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
  },
};
</script>
