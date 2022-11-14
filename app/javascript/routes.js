import { createWebHistory, createRouter } from 'vue-router'

import PageIndex from '@/views/pages/index.vue';
import Error404 from '@/views/pages/error_404.vue';
import NewWorkspace from '@/modules/workspace/NewWorkspace.vue';
import EmailForm from '@/modules/user/EmailForm.vue';
import PasswordForm from '@/modules/user/PasswordForm.vue';
import WorkspaceDashboard from '@/modules/workspace/WorkspaceDashboard.vue';
import SplitPanes from './views/pages/SplitPanes.vue'

const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    { path: '/', component: PageIndex, name: 'root_path' },
    { path: '/404', component: Error404 },
    { path: '/:catchAll(.*)', redirect: '/404' },
    { path: '/screen', component: SplitPanes, name:'screen'},
    { path: '/new_workspace', component: NewWorkspace, name: 'new_workspace' },
    { path: '/invite_user', component: EmailForm, name: 'invite_user' },
    { path: '/password_form', component: PasswordForm, name: 'password_form' },
    { path: '/workspace_dashboard', component: WorkspaceDashboard, name: 'workspace_dashboard' },
  ]
});

export default router;
