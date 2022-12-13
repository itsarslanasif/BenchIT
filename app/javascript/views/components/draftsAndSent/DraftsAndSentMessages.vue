<template>
  <div class="h-screen">
    <div class="flex p-1 px-3">
      <div class="flex overflow-y-hidden text-ellipsis p-1">
        <p class="text-slate-800 text-xl font-semibold">{{ $t('sidebar.draft_and_sent') }}</p>
      </div>
    </div>
    <nav
      class="container px-4 py-2 mx-auto border flex justify-between items-center"
    >
      <div class="flex items-center justify-between">
        <router-link
          class="mr-6 text-slate-800"
          v-for="routes in links"
          v-bind:key="routes.id"
          :to="`${routes.page}`"
          >{{ routes.text }}</router-link
        >
      </div>
    </nav>
    <router-view :key="$route.fullPath"/>
  </div>
</template>

<script>
export default {
  data() {
    return {
      links: [
        {
          id: 0,
          text: 'Drafts',
          page: '/',
        },
        {
          id: 1,
          text: 'Scheduled',
          page: '/',
        },
        {
          id: 2,
          text: 'Sent',
          page: '/recently_sent_messages',
        },
      ],
    };
  },
};
</script>

<style scoped>
.border {
  border-width: 0.5px 0 0.5px 0;
  border-style: solid;
  border-color: gray;
}
</style>
