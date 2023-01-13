<template>
  <div class="flex p-2 rounded-md border border-black-500 shadow-sm">
    <div @click="showMemberClickListener(true)" class="flex cursor-pointer">
      <img
        class="w-6 h-6 -ml-1 rounded-md border border-black-500"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      />
      <img
        class="w-6 h-6 -ml-1 rounded-md border border-black-500"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      />
      <img
        class="w-6 h-6 -ml-1 rounded-md border border-black-500"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      />
      <div class="w-3 ml-1">
        <p class="ml-1 font-bold text-black">
          {{ channelDetailStore.channelMembers.length }}
        </p>
      </div>
    </div>
    <n-divider vertical class="self-center text-black" />
    <div class="ml-3">
      <AddPeopleToChannel :channelName="channelName" />
    </div>
  </div>
</template>

<script>
import AddPeopleToChannel from './AddPeopleToChannel.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore.js';
import { NDivider } from 'naive-ui';
export default {
  props: ['showMemberClickListener', 'channelId', 'channelName'],
  components: {
    AddPeopleToChannel,
    NDivider,
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
      try {
        this.count = await this.channelDetailStore.getChannelMembersCount(
          channelId
        );
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>
