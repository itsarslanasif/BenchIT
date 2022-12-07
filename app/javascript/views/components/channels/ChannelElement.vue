<template>
  <div class="flex hover:bg-slate-50 w-20 cursor-pointer" @click="OpenChannelDetailModal(true)">
    <i class="fas fa-hashtag mt-3 ml-1"></i>
    <p class="font-black text-2xl ml-1">{{ this.channelname }}</p>
    <i class="fa-solid fa-chevron-down mt-3"></i>
  </div>
  <div v-if="modalopen">
    <ChannelDetailModel :channelname = "channelname" :channelid="id" :detailsopen = "OpenChannelDetailModal" class="m-auto absolute inset-x-0" />
  </div>
</template>

<script>
import { useRoute } from 'vue-router'
import ChannelDetailModel from '../../containers/ChannelDetailModal.vue'
import { getChannels } from '../../../api/channels/channels'
export default {
  name: 'Channel',
  components: { ChannelDetailModel },

  data() {
    return {
      channelname: '',
      modalopen: false,
      id: 0,
    };
  },

  methods: {
    OpenChannelDetailModal(open) {
      this.modalopen = open;
    }
  },

  async mounted() {
    const route = useRoute();
    const result = await getChannels();
    this.channelname = (result[route.params.id-1].name);
    this.id = route.params.id;
  },
};
</script>

