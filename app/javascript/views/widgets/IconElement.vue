<template>
  <div
    class="px-2 py-1 text-base font-medium flex text-left text-slate-50 hover:bg-primaryHover -mr-2 p-0 cursor-pointer"
    @click="elementClicked"
  >
    <font-awesome-icon :icon="icon" class="w-8 mt-1" />
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
          this.$router.replace({ path: '/members' });
          break;
        case 'Drafts & Sent':
          this.$router.replace({ path: '/drafts_sent_messages' });
          break;
      }
    },
  },
};
</script>
