<template>
  <div class="max-h-full">
    <search-bar class="border-b border-slate-400 bg-secondary"/>
    <router-view class="relative"/>
  </div>
</template>

<script>
import NavBar from './_nav.vue';
import searchBarVue from './searchBar.vue';
import { useProfileStore } from '../../stores/useProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { onMounted } from 'vue'

export default {
  components: {
    'nav-bar': NavBar,
    'search-bar': searchBarVue
  },
}
</script>
