<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>{{ $t('channels.starred') }}</template>
        <h5 v-for="channel in starredChannels" :key="channel.id" class="hover:bg-primaryHover">
          <ChannelItem :channel="channel" :goTo="goToChannelChat" :toggleShow="toggleChannelOptionShow"
            :isShowOptions="showChannelOptions" />
        </h5>
      </AccordionItem>
    </AccordionList>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import ChannelItem from './ChannelItem.vue';
import { useStarredChannelsStore } from '../../../stores/useStarredChannelsStore';
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
    const starredChannels = useStarredChannelsStore();
    return {
      starredChannels,
    };
  },
  methods: {
    goToChannelChat(chatURL) {
      this.$router.push(chatURL);
      console.log(this.starredChannels.length);
    },
    toggleChannelOptionShow() {
      this.showChannelOptions = !this.showChannelOptions;
    },
  },
};
</script>
