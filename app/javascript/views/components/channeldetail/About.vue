<template>
  <div v-if="selectedChat" class="bg-white flex flex-col p-5">
    <span
      class="border border-black-300 cursor-pointer hover:bg-transparent p-2 rounded-t-lg border-b-0"
    >
      <p class="font-bold">{{ $t('channeldetail.topic') }}</p>
      <p>{{ selectedChat.topic }}</p>
    </span>
    <span
      class="border border-black-300 cursor-pointer hover:bg-transparent p-2 border-b-1"
    >
      <p class="font-bold">{{ $t('channeldetail.description') }}</p>
      <p>{{ selectedChat.description }}</p>
    </span>
    <span
      class="border border-black-300 cursor-pointer hover:bg-transparent p-3 border-t-0"
    >
      <p class="font-bold">{{ $t('channeldetail.created_by') }}</p>
      <p>
        {{ selectedChat.creator_name }} on
        {{ formatDate(selectedChat.created_at) }}
      </p>
    </span>
    <span
      class="border border-black-300 cursor-pointer hover:bg-transparent p-2 mb-4 border-t-0 rounded-b-lg"
      @click="leaveChannel"
    >
      <p class="text-danger font-bold">{{ $t('channeldetail.leave') }}</p>
    </span>
    <span
      class="border border-black-300 cursor-pointer hover:bg-transparent p-2 rounded-lg"
    >
      <p class="font-bold">{{ $t('channeldetail.files') }}</p>
      <p>{{ $t('channeldetail.filecontent') }}</p>
    </span>
  </div>
</template>

<script>
import { useChannelStore } from '../../../stores/useChannelStore';
import moment from 'moment';

export default {
  setup() {
    const channelStore = useChannelStore();
    return {
      channelStore,
    };
  },

  props: ['selectedChat'],

  methods: {
    async leaveChannel() {
      await this.channelStore.leaveChannel(this.selectedChat.id);
      this.$router.push('/');
    },
    formatDate(date) {
      return moment(date).format('MMMM Do, YYYY');
    },
  },
};
</script>
