<template>
  <div
    class="px-2 py-1 text-sm rounded-md flex text-left text-black-400 hover:bg-primaryHover p-0 cursor-pointer"
    @click="elementClicked"
  >
    <font-awesome-icon :icon="icon" class="w-8 mt-1" />
    <div class="truncate">{{ name }}</div>
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
        case 'Mentions & Reactions':
          this.$router.replace({ path: '/mentions_and_reactions' });
          break;
      }
    },
  },
};
</script>
