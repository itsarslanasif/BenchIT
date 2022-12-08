<template>
  <div @click="MarkStar">
    <div v-if="favchannel">
      <i class="fa-solid fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i>
    </div>
    <div v-else>
      <i class="fa-regular fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i>
    </div>
  </div>
</template>

<script>
import { star } from '../../../api/starunstar/star.js'
import { unstar } from '../../../api/starunstar/unstar.js'
export default {
  name: 'StarUnstar',

  props: {
    channelId: Number
  },

  data() {
    return {
      favchannel: false,
      favchannelid: 0,
    }
  },
  methods: {
    MarkStar() {
      if (!this.favchannel) {
        this.favchannel = !this.favchannel;
        star(
          {
            favourable_type: "BenchChannel",
            favourable_id: this.channelId
          }
        ).then(response => {
          this.favchannelid = response.data.favourite_id;
        }
        )
      }
      else {
        this.favchannel = !this.favchannel;
        unstar(this.favchannelid);
      }
    }
  }
}

</script>

