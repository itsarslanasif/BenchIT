<template>
  <div class="max-h-full">
    <router-view class="relative"/>
  </div>
</template>

<script>
import NavBar from './_nav.vue';
import searchBarVue from './searchBar.vue';

export default {
  components: {
    'nav-bar': NavBar,
    'search-bar': searchBarVue
  },
}
</script>
