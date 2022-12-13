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
export default {
  name: 'StarUnstar',

  props: {
    channelId: Number,
  },

  data() {
    return {
      favChannel: false,
      favChannelId: 0,
    };
  },
  methods: {
    MarkStar() {
      this.favChannel = !this.favChannel;

      if (this.favChannel) {
        star({
          favourable_type: 'BenchChannel',
          favourable_id: this.channelId,
        }).then(response => {
          this.favChannelId = response.data.favourite.id;
        });
      } else {
        unstar(this.favChannelId);
      }
    },
  },
};
</script>
