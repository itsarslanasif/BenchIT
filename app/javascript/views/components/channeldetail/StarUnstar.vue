<template>
  <div class="w-10 cursor-pointer" @click="MarkStar">
    <div v-if="favChannel">
      <i
        class="fa-solid fa-star border border-black-300 px-4 rounded p-2 ml-6 m-2"
      ></i>
    </div>
    <div v-else>
      <i
        class="fa-regular fa-star border border-black-300 px-4 rounded p-2 ml-6 m-2"
      ></i>
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
  beforeUnmount() {
    this.favChannelId = 0;
  },
  methods: {
    MarkStar() {
      this.favChannel = !this.favChannel;
      try {
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
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>
