<template>
  <n-modal v-model:show="showModal">
    <n-card
      style="width: 600px"
      title="Modal"
      :bordered="false"
      size="huge"
      role="dialog"
      aria-modal="true"
    >
      <template #header-extra> Oops! </template>
      Content
      <template #footer> Footer </template>
    </n-card>
  </n-modal>
</template>

<script>
import { NModal, NInput, NCard, NIcon, NSpace, NDivider } from 'naive-ui';
export default {
  components: {
    NModal,
    NInput,
    NCard,
    NIcon,
    NSpace,
    NDivider,
  },
  props: [showModal],
};
</script>
