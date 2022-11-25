<template>
  <div class="text-base flex text-center text-slate-50 hover:bg-primaryHover -mr-2 p-0">
    <div class="w-8">{{ icon }}</div>
    <div>{{ name }}</div>
  </div>
</template>

<script>
export default {
  name: 'IconElement',

  props: {
    icon: String,
    name: String,
  },
};
</script>
