<template>
  <div class="bg-primary w-1/3 rounded-md">
    <div
      v-for="modal in modalArray"
      :key="modal.title"
      class="rounded p-5 hover:bg-primaryHover"
      @click="modal.func"
    >
      {{ modal.title }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'modal',
  props: ['modalArray'],
};
</script>
