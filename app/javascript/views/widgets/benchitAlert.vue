<template>
  <div class="absolute z-10 top-10 right-0 mr-4 mt-24">
    <n-alert
      class="pr-20"
      v-if="success"
      title="Success"
      type="success"
      :onClose="setApiResponseStatusNull"
      closable
    >
      {{ successMessage }}
    </n-alert>

    <n-alert
      v-else
      class="pr-20"
      title="Error"
      type="error"
      :onClose="closeAlert"
      closable
    >
      {{ errorMessage }}
    </n-alert>
  </div>
</template>

<script>
import { NAlert } from 'naive-ui';
export default {
  name: 'BenchITAlert',
  components: { NAlert },
  props: [
    'errorMessage',
    'successMessage',
    'success',
    'setApiResponseStatusNull',
  ],
  setup(props) {
    const closeAlert = () => {
      props.setApiResponseStatusNull();
    };
    return {
      closeAlert,
    };
  },
};
</script>
