import { createWebHistory, createRouter } from 'vue-router'

import PageIndex from '@/views/pages/index.vue';
import Error404 from '@/views/pages/error_404.vue';
import NewWorkspace from '@/modules/workspace/NewWorkspace.vue';
import EmailForm from '@/modules/workspace/EmailForm.vue';
import PasswordForm from '@/modules/workspace/PasswordForm.vue';

const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    { path: '/', component: PageIndex, name: 'root_path' },
    { path: '/404', component: Error404 },

    { path: '/:catchAll(.*)', redirect: '/404' },
    { path: '/new_workspace', component: NewWorkspace, name: 'new_workspace' },
    { path: '/invite_user', component: EmailForm, name: 'invite_user' },
    { path: '/password_form', component: PasswordForm, name: 'password_form' },
  ]
});

export default router;
