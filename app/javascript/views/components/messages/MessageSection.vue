<template>
  <div class="text-sm">
    <div v-html="text"></div>
  </div>
</template>

<script>
import { Remarkable } from 'remarkable';
export default {
  props: {
    section: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      text: ''
    }
  },
  mounted() {
    const html = new Remarkable({ html: true });
    this.text = html.render(this.section.text.text)
  }
}
</script>
