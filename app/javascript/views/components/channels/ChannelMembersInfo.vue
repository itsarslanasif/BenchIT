<template>
  <div class="flex p-2 bg-slate-400 rounded-md border-2 border-black">
    <div @click="showMemberClickListener(true)" class="flex cursor-pointer">
      <img
        class="w-6 h-6 -ml-1 rounded-md border-2 border-primary"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      />
      <img
        class="w-6 h-6 -ml-1 rounded-md border-2 border-primary"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      />
      <img
        class="w-6 h-6 -ml-1 rounded-md border-2 border-primary"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      />
      <p class="ml-1 font-bold text-white">{{ count }}</p>
    </div>
    <div class="rounded-md ml-2 border-2 border-black"></div>
    <div class="ml-3 cursor-pointer">
      <AddPeopleToChannel />
    </div>
  </div>
</template>

<script>
import AddPeopleToChannel from './AddPeopleToChannel.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore.js';
export default {
  props: ['showMemberClickListener', 'channelId'],
  components: {
    AddPeopleToChannel,
  },
  mounted() {
    this.getChannelMembersCount();
  },
  setup() {
    const channelDetailStore = useChannelDetailStore();
    return { channelDetailStore };
  },
  data() {
    return {
      count: '',
    };
  },
  methods: {
    async getChannelMembersCount() {
      let channelId = window.location.pathname.split('/')[2];
      this.count = await this.channelDetailStore.getChannelMembersCount(
        channelId
      );
    },
  },
};
</script>
<style scoped>
.vl {
  width: 10px;
  background-color: black;
  height: 500px;
}
</style>
