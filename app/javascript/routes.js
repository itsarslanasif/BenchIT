import { createWebHistory, createRouter } from 'vue-router';

import PageIndex from '@/views/pages/index.vue';
import Error404 from '@/views/pages/error_404.vue';
import NewWorkspace from '@/modules/workspace/NewWorkspace.vue';
import JoinWorkspace from '@/modules/workspace/JoinWorkspace.vue';
import Members from '@/modules/members/members.vue';
import EmailForm from '@/modules/workspace/EmailForm.vue';
import PasswordForm from '@/modules/workspace/PasswordForm.vue';
import SplitPanes from './views/pages/SplitPanes.vue';

const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    { path: '/', component: PageIndex, name: 'root_path' },
    { path: '/404', component: Error404 },
    { path: '/:catchAll(.*)', redirect: '/404' },
    { path: '/new_workspace', component: NewWorkspace, name: 'new_workspace' },
    { path: '/join_workspace/:workspace_id', component: JoinWorkspace, name: 'join_workspace' },
    { path: '/members', component: Members, name: 'members' },
    { path: '/invite_user', component: EmailForm, name: 'invite_user' },
    { path: '/password_form', component: PasswordForm, name: 'password_form' },
    { path: '/screen', component: SplitPanes, name: 'screen' },
    { path: '/users/:id', component: SplitPanes, name: 'user_chat' },
    { path: '/channels/:id', component: SplitPanes, name: 'channel_chat' },
    { path: '/groups/:id', component: SplitPanes, name: 'group_chat' },
  ],
});

export default router;
