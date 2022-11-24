<template>
  <div class="max-h-full">
    <search-bar class="border-b border-slate-400 bg-secondary"/>
    <router-view class="relative"/>
  </div>
</template>

<script>
import NavBar from './_nav.vue';
import searchBarVue from './searchBar.vue';
import { useUserStore } from '../../stores/useUserStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { onMounted } from 'vue'

export default {
  components: {
    'nav-bar': NavBar,
    'search-bar': searchBarVue
  },
  // setup() {
  //   const userStore = useUserStore()
  //   useChannelStore()
  //   onMounted(() => {
  //     userStore.index()
  //   })
  // },
}
</script>
