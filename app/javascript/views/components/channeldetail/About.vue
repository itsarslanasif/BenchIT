<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.topic') }}</p>
      <p>{{ this.topic }}</p>
    </div>
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.description') }}</p>
      <p>{{ this.description }}</p>
    </div>
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.created_by') }}</p>
      <p>{{ this.created_by }}</p>
    </div>
    <div
      class="bg-danger text-white hover:bg-dangerHover p-2 rounded-md"
      @click="leaveChannel"
    >
      <p class="font-black">{{ $t('channeldetail.leave') }}</p>
    </div>
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.files') }}</p>
      <p>{{ $t('channeldetail.filecontent') }}</p>
    </div>
  </div>
</template>

<script>
import { memberLeaveChannel } from '../../../api/channels/channels';
import { useChannelStore } from '../../../stores/useChannelStore';
export default {
  name: 'About',
  data() {
    return {
      topic: 'Add a topic',
      description: 'Add description',
      created_by: 'Irfan Nazeer',
    };
  },
  beforeUnmount() {
    this.topic = null;
    this.description = null;
    this.created_by = null;
  },
  props: {
    channelname: String,
  },
  setup() {
    function getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    }
    const channelStore = useChannelStore();
    const id = getIndexByParams(2);
    return {
      id,
      channelStore,
    };
  },

  methods: {
    async leaveChannel() {
      try {
        const response = await memberLeaveChannel(this.id);
        this.channelStore.leaveChannel(this.id);
        this.$router.push('/');
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>
