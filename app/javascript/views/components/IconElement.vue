<template>
  <div
    class="
      text-base
      flex
      text-center text-slate-50
      hover:bg-primaryHover
      -mr-2
      p-0
    "
  >
    <div class="w-8 cursor-pointer" @click="elementClicked">{{ icon }}</div>
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
  methods: {
    elementClicked() {
      switch (this.name) {
        case 'People & user groups':
          window.location.replace('http://127.0.0.1:5100/members');
          break;
        default:
        // code block
      }
    },
  },
};
</script>
