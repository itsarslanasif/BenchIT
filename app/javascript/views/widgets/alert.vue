<template>
  {{ downloading() }}
</template>
<script>
import { NButton, NSpace, useMessage } from 'naive-ui';
import { useDownloadsStore } from '../../stores/useDownloadsStore';

export default {
  components: { NButton, NSpace },
  setup() {
    const message = useMessage();
    const downloadsStore = useDownloadsStore();
    return {
      downloadsStore,
      message,
      alert: downloadsStore.getMessage,
    };
  },
  methods: {
    downloading() {
      this.message.success(this.alert);
    },
  },
};
</script>
