<template>
  {{ loading() }}
</template>

<script>
import { NButton, NSpace, useMessage } from 'naive-ui';
import { CONSTANTS } from '../../../assets/constants';

export default {
  components: { NButton, NSpace },
  setup() {
    const message = useMessage();
    return {
      loading() {
        message.loading(CONSTANTS.SWITCHING_WORKSPACE, {
          duration: 2000,
        });
      },
    };
  },
};
</script>
