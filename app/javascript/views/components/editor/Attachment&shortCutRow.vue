<template>
  <div
    class="flex px-1 py-2 w-full hover-trigger hover:bg-slate-800 rounded-md group hover:text-white"
    @click="onSelect(object)"
  >
    <span> <font-awesome-icon class="h-5 w-5" :icon="object.icon" /></span>
    <span class="px-2 cursor-pointer">{{ object.label }}</span>
  </div>
</template>

<script>
export default {
  props: ['object'],
  methods: {
    onSelect(object) {
      if (object.label === 'Create a text snippet') {
      }
    },
  },
};
</script>
