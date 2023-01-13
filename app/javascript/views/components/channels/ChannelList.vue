<template>
  <AccordionList>
    <AccordionItem default-opened="true">
      <template #summary>{{ heading }}</template>
      <h5 v-for="channel in channels" :key="channel.id" class="hover:bg-primaryHover">
        <ChannelItem :channel="channel" :goTo="goToChannelChat" />
      </h5>
    </AccordionItem>
  </AccordionList>
</template>

<script>
import ChannelItem from './ChannelItem.vue';
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import { useChannelStore } from '../../../stores/useChannelStore';
export default {
  components: {
    ChannelItem,
    AccordionItem,
    AccordionList
  },
  setup() {
    const channelStore = useChannelStore();
    return { channelStore };
  },
  props: ['channels', 'heading'],
  methods: {
    goToChannelChat(chatURL, channel) {
      this.$router.push(chatURL);
    },
  }
}
</script>
