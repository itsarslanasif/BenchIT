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
      class="px-4 py-2 mx-auto border flex justify-between items-center border-black-300 border-r-0 border-l-0"
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
    <div class="flex flex-col justify-center items-center mt-10">
      <font-awesome-icon
        icon="fa-solid fa-pencil"
        class="text-2xl mb-2"
      ></font-awesome-icon>
      <p class="font-bold text-base text-center w-100">
        {{ $t('drafts.title') }}
      </p>
      <p class="text-base text-center w-100">
        {{ $t('drafts.description') }}
      </p>
    </div>
  </div>
</template>

<script>
import { CONSTANTS } from '../../../assets/constants';
export default {
  data() {
    return {
      links: [
        {
          id: 0,
          text: CONSTANTS.DRAFTS,
          page: '/drafts_sent_messages',
        },
        {
          id: 1,
          text: CONSTANTS.SCHEDULED,
          page: '/',
        },
        {
          id: 2,
          text: CONSTANTS.SENT,
          page: '/recently_sent_messages',
        },
      ],
    };
  },
  beforeUnmount() {
    this.links = null;
  },
};
</script>

<style scoped>
.router-link-exact-active {
  border-bottom: 2px solid green;
  color: black;
}
</style>
