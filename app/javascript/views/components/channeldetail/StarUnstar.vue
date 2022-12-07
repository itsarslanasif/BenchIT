<template>
  <div @click="MarkStar">
    <div v-if="this.favchannel">
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
    channelid: Number
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
            "favourable_id": this.channelid
          }
        ).then(response => {
          this.favchannelid = response.data.favourite_id;
          console.log(this.favchannelid);
        }
        )
          .catch(err => console.log(err));
      }
      else {
        this.favchannel = !this.favchannel;
        unstar(this.favchannelid);
      }
    }
  }
  // this.favchannel = !this.favchannel;
  //   axios.delete('http://127.0.0.1:5100/api/v1/favourites/' + this.favchannelid)
  //     .then(response => console.log(response));
  //   this.favchannelid = 0;
  //   console.log(this.favchannelid);
}

</script>

