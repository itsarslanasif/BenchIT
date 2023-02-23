<template>
  <video
    class="border border-transparent rounded-lg w-24 h-24"
    :src="createUrl"
    controls
  ></video>
</template>

<script>
export default {
  props: ['blob'],
  computed: {
    createUrl() {
      return URL.createObjectURL(this.blob);
    },
  },
};
</script>
