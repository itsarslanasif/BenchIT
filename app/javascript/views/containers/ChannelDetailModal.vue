<template>
  <Transition name="modal-fade">
    <div class="modal ml-20 mt-20 mb-20">
      <header>
        <button type="button" class="btn-close text-2xl" @click="detailsopen(false)">x
        </button>
        <div class="flex ml-10">
          <i class="fas fa-hashtag mt-3 ml-1"></i>
          <p class="font-black text-2xl ml-1"> {{ this.channelname }} </p>
        </div>
        <div class="flex ml-10">
          <p class="ml-3 hover:font-black cursor-pointer">
            {{ CONSTANTS.ABOUT }}
          </p>
          <p class="ml-3 hover:font-black cursor-pointer">
            {{ CONSTANTS.MEMBERS }}
          </p>
          <p class="ml-3 hover:font-black cursor-pointer">
            {{ CONSTANTS.INTEGRATIONS }}
          </p>
          <p class="ml-3 hover:font-black cursor-pointer">
            {{ CONSTANTS.SETTINGS }}
          </p>
        </div>
      </header>
      <About :channelname = "this.channelname" />
    </div>
  </Transition>
</template>

<script>
import About from '../components/channeldetail/About.vue';
import { CONSTANTS } from '../../assets/constants.js';
export default {
  name: 'ChannelDetailModal',
  components: { About },

  data() {
    return {
      CONSTANTS: CONSTANTS,
    }
  },

  props: {
    channelname: String,
    detailsopen: Function
  }
}
</script>
