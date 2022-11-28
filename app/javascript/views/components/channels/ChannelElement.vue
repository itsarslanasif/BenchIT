<template>
  <h1>{{ name }}</h1>
</template>

<script>
import { useRoute } from 'vue-router';

export default {
  name: 'Channel',

  data() {
    return {
      name: '',
    };
  },
  async mounted() {
    const route = useRoute();
    this.name = route.params.name;
  },
};
</script>
