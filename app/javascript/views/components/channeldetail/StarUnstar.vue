<template>
  <div @click="MarkStar">
    <div v-if="favChannel">
      <i class="fa-solid fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i>
    </div>
    <div v-else>
      <i class="fa-regular fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i>
    </div>
  </div>
</template>

<script>
import { star } from '../../../api/starunstar/star.js';
import { unstar } from '../../../api/starunstar/unstar.js';
import { useStarredChannelsStore } from '../../../stores/useStarredChannelsStore';
export default {
  name: 'StarUnstar',
  setup() {
    const starredChannelsStore = useStarredChannelsStore();
    return {
      starredChannelsStore,
    };
  },

  props: {
    channelId: Number,
    channelName: String,
  },

  data() {
    return {
      favChannel: false,
      favChannelId: 0,
      channel: { channelId: null, channelName: null },
    };
  },
  beforeUnmount() {
    this.favChannelId = 0;
  },
  methods: {
    MarkStar() {
      this.favChannel = !this.favChannel;
      try {
        if (this.favChannel) {
          this.setChannel();
          star({
            favourable_type: 'BenchChannel',
            favourable_id: this.channelId,
          }).then(response => {
            this.favChannelId = response.data.favourite.id;
          });
        } else {
          unstar(this.favChannelId);
          this.unsetChannel();
        }
      } catch (e) {
        console.error(e);
      }
    },
    setChannel() {
      this.channel.channelId = this.channelId;
      this.channel.channelName = this.channelName;
      this.starredChannelsStore.addStarredChannel(this.channel);
    },
    unsetChannel() {
      this.channel.channelId = null;
      this.channel.channelName = null;
      this.starredChannelsStore.removeStarredChannel(this.channel);
    },
  },
};
</script>
