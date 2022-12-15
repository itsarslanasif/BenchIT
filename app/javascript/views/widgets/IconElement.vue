<template>
  <div
    class="text-base flex text-center text-slate-50 hover:bg-primaryHover -mr-2 p-0 cursor-pointer"
  >
    <div class="w-8" @click="elementClicked">{{ icon }}</div>
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
        case 'People & User Group':
          this.$router.replace({ path: '/members' })
          break;
        case 'Drafts & Sent':
          this.$router.replace({ path: '/drafts_sent_messages' })
          break;
      }
    },
  },
};
</script>
