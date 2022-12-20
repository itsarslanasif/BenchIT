<template>
  <div class="max-h-full">
    <router-view class="relative"/>
    <EditProfileVue />
  </div>
</template>

<script>
import NavBar from './_nav.vue';
import searchBarVue from './searchBar.vue';
import EditProfileVue from '../components/profile/EditProfile.vue';
export default {
  components: {
    'nav-bar': NavBar,
    'search-bar': searchBarVue,
    EditProfileVue
  },
}
</script>
