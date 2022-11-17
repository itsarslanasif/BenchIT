<template>
  <p>{{ icon }} {{ space }} {{ name }}</p>
</template>

<script>
 export default {
  name : "IconElement",

  props: {
    icon: String,
    space: String,
    name: String
  }
 }
</script>
