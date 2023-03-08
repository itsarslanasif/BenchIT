<template>
  <div class="flex p-1 mx-2 rounded-md border border-light">
    <div class="flex cursor-pointer" @click="showMemberClickListener(true)">
      <div
        v-for="member in getChannelMembers"
        :key="member.id"
        class="flex cursor-pointer"
      >
        <img class="w-6 h-6 rounded" :src="member.image_url" />
      </div>
      <div class="w-3 ml-1">
        <p class="font-bold text-black">
          {{ channelDetailStore.channelMembers.length }}
        </p>
      </div>
    </div>
    <n-divider vertical class="self-center text-black" />
    <div class="ml-1">
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
  computed: {
    getChannelMembers() {
      return this.channelDetailStore.channelMembers.slice(-3);
    },
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
<style>
.custom-border {
  border: 1px solid rgba(19, 19, 19, 0.139);
}
</style>
