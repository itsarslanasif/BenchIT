<template>
  <vsa-list>
    <vsa-item>
      <vsa-heading>
        Channels
      </vsa-heading>

      <vsa-content>
        This is the content
      </vsa-content>
    </vsa-item>
  </vsa-list>
</template>

<script>
import { VsaList, VsaItem, VsaHeading, VsaContent } from 'vue-simple-accordion';
import 'vue-simple-accordion/dist/vue-simple-accordion.css';

export default {
  components: {
    VsaList,
    VsaItem,
    VsaHeading,
    VsaContent,
  },
};
</script>

<style>
body {
  color: white;
}
</style>
