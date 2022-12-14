<template>
  <div class="h-screen">
    <div class="flex p-1 px-3">
      <div class="flex overflow-y-hidden text-ellipsis p-1">
        <p class="text-slate-800 text-xl font-semibold">
          {{ $t('sidebar.draft_and_sent') }}
        </p>
      </div>
    </div>
    <nav
      class="container px-4 py-2 mx-auto border flex justify-between items-center"
    >
      <div class="flex items-center justify-between">
        <router-link
          class="mr-6 text-black-600 -mb-2 hover:text-black-900 text-sm"
          v-for="routes in links"
          v-bind:key="routes.id"
          :to="`${routes.page}`"
          >{{ routes.text }}</router-link
        >
      </div>
    </nav>
    <router-view :key="$route.fullPath" />
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
          page: '/drafts_sent_messages',
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
.router-link-exact-active {
  border-bottom: 2px solid green;
  color: black;
}
</style>
