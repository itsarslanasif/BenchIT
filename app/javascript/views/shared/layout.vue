<template>
  <div class="max-h-full">
    <n-config-provider :theme-overrides="themeOverrides">
      <router-view class="relative" />
    </n-config-provider>
  </div>
</template>

<script>
import NavBar from './_nav.vue';
import searchBarVue from './searchBar.vue';
import { NConfigProvider } from 'naive-ui';

export default {
  components: {
    NConfigProvider,
    'nav-bar': NavBar,
    'search-bar': searchBarVue,
  },
  data() {
    return {
      themeOverrides: {
        common: {
          primaryColor: '#1E293B',
          primaryColorHover: '#475569',
        },
      },
    };
  },
};
</script>
