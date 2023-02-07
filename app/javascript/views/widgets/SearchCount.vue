<template lang="">
  <div class="flex gap-1">
    <div>
      {{ heading }}
    </div>
    <div v-if="category">
      {{ category.length }}
    </div>
  </div>
</template>
<script>
export default {
  props: {
    category: {
      type: Object
    },
    heading: {
      type: String
    }
  }
}
</script>
