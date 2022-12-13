<template>
  <div
    class="text-base flex text-center text-slate-50 hover:bg-primaryHover -mr-2 p-0"
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
        case 'People & User Group':
          window.location.replace(
            `${import.meta.env.VITE_APP_SERVER_URL}members`
          );
        case 'Drafts & Sent':
          this.$router.push('drafts_sent_messages');
          break;
      }
    },
  },
};
</script>
