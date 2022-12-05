<template>
  <div class="modal w-1/3 absolute z-10 inset-px bg-white border-2 rounded-2xl p-2 shadow-2xl m-10 ">
    <button type="button" class="btn-close text-2xl float-right mr-6" @click="detailsopen(false)">x
    </button>
    <div class="flex ml-10">
      <p class="font-black text-2xl ml-1"> <i class="fas fa-hashtag mr-2"></i>{{ this.channelname }} </p>
    </div>
    <div class="flex ml-4">
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
