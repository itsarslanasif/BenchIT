<template>
  <div class="flex p-2 rounded-md border border-black-500 shadow-sm">
    <div class="flex cursor-pointer">
      <div
        v-for="member in messageStore.selectedChat.profiles"
        :key="member.id"
        class="flex cursor-pointer"
      >
        <img class="w-6 h-6 mr-1 rounded" :src="member.image_url" />
      </div>
      <div class="w-3 ml-1">
        <p class="ml-1 font-bold text-black">
          {{ messageStore?.selectedChat?.profiles?.length }}
        </p>
      </div>
    </div>
    <n-divider vertical class="self-center text-black" />
    <!-- <div class="ml-3">
      <AddPeopleToChannel :channelName="channelName" />
    </div> -->
  </div>
</template>

<script>
import AddPeopleToChannel from './AddPeopleToChannel.vue';
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore.js';
import { NDivider } from 'naive-ui';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  props: ['showMemberClickListener', 'channelId', 'channelName'],
  components: {
    AddPeopleToChannel,
    NDivider,
  },
  mounted() {
    // this.getChannelMembersCount();
  },
  setup() {
    const channelDetailStore = useChannelDetailStore();
    const messageStore = useMessageStore();
    return { channelDetailStore, messageStore };
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
