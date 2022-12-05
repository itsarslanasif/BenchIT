<template>
  <div class="modal absolute z-10 inset-px		">
    <button type="button" class="btn-close text-2xl" @click="detailsopen(false)">x
    </button>
    <div class="flex ml-10">
      <i class="fas fa-hashtag mt-3 ml-1"></i>
      <p class="font-black text-2xl ml-1"> {{ this.channelname }} </p>
    </div>
    <div class="flex ml-10">
      <p class="ml-3 hover:font-black cursor-pointer">
        {{ $t('channeldetail.about') }}
      </p>
      <p class="ml-3 hover:font-black cursor-pointer">
        {{ $t('channeldetail.members') }}
      </p>
      <p class="ml-3 hover:font-black cursor-pointer">
        {{ $t('channeldetail.integrations') }}
      </p>
      <p class="ml-3 hover:font-black cursor-pointer">
        {{ $t('channeldetail.settings') }}
      </p>
    </div>
    <About :channelname="this.channelname" />
  </div>
</template>

<script>
import About from '../components/channeldetail/About.vue';
export default {
  name: 'ChannelDetailModal',
  components: { About },

  props: {
    channelname: String,
    detailsopen: Function
  }
}
</script>
