<template>
  <div class="slack-section">
    <div v-html="section.text.text"></div>
  </div>
</template>

<script>
export default {
  props: {
    section: {
      type: Object,
      required: true,
    },
  },
}
</script>

<style scoped>
.slack-section {
  background-color: #fafafa;
}
</style>
