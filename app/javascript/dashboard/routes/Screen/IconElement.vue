<template>
  <p>{{ icon }} {{ space }} {{ name }}</p>
</template>

<script>
export default {
  props: {
    icon: {
      type: String,
      default: '',
    },
    space: {
      type: String,
      default: '',
    },
    name: {
      type: String,
      default: '',
    },
  },
};
</script>
