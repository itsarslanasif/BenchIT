<template>
  <div
    class="
      modal
      cursor-pointer
      w-1/3
      absolute
      z-10
      inset-px
      bg-white
      rounded-xl
      p-2
      shadow-2xl
      m-10
    "
  >
    <button
      type="button"
      class="
        btn-close
        text-2xl
        float-right
        px-5
        hover:bg-transparent
        rounded
        self-center
      "
      @click="detailsopen(false)"
    >
      x
    </button>
    <p class="font-bold text-2xl pl-8">
      <i class="fas fa-hashtag mr-1"></i>{{ this.channelName }}
    </p>
    <StarUnstar />
    <div class="flex ml-4">
      <p
        class="
          ml-3
          hover:bg-transparent hover:font-bold
          px-2
          rounded
          cursor-pointer
        "
      >
        {{ $t('channeldetail.about') }}
      </p>
      <p
        class="
          ml-3
          hover:bg-transparent hover:font-bold
          px-2
          rounded
          cursor-pointer
        "
      >
        {{ $t('channeldetail.members') }}
      </p>
      <p
        class="
          ml-3
          hover:bg-transparent hover:font-bold
          px-2
          rounded
          cursor-pointer
        "
      >
        {{ $t('channeldetail.integrations') }}
      </p>
      <p
        class="
          ml-3
          hover:bg-transparent hover:font-bold
          px-2
          rounded
          cursor-pointer
        "
      >
        {{ $t('channeldetail.settings') }}
      </p>
    </div>
    <About :channelName="this.channelName" />
  </div>
</template>

<script>
import About from '../components/channeldetail/About.vue';
import StarUnstar from '../components/channeldetail/StarUnstar.vue';
export default {
  name: 'ChannelDetailModal',
  components: { About, StarUnstar },

  props: {
    channelName: String,
    detailsopen: Function,
  },
};
</script>
