<template>
  {{ error() }}
</template>

<script>
import { useMessage } from 'naive-ui';
import { useErrorStore } from '../../stores/useErrorStore';
export default {
  setup() {
    const message = useMessage();
    const errorStore = useErrorStore()

    const error = () => {
      message.error(errorStore.error);
    }

    return {
      error
    }
  },
};
</script>
