import { createWebHistory, createRouter } from 'vue-router'

import PageIndex from '@/views/pages/index.vue';
import Error404 from '@/views/pages/error_404.vue';

const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    { path: '/', component: PageIndex, name: 'root_path' },
    { path: '/404', component: Error404 },

    { path: '/:catchAll(.*)', redirect: '/404' }
  ]
});

export default router;
