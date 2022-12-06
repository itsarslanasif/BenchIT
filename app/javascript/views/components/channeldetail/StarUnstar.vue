<template>
  <div @click="MarkStar">
    <div v-if="this.favchannel">
      <i class="fa-solid fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i>
    </div>
    <div v-else>
      <i class="fa-regular fa-star border-2 w-10 rounded p-2 ml-8 m-2"></i>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StarUnstar',

  data() {
    return {
      favchannel: false,
    }
  },
  methods: {
    MarkStar() {
      this.favchannel = !this.favchannel;
    }
  }
}
</script>

