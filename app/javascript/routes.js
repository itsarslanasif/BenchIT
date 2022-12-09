import { createWebHistory, createRouter } from 'vue-router';
import PageIndex from '@/views/pages/index.vue';
import Error404 from '@/views/pages/error_404.vue';
import NewWorkspace from '@/views/components/workspace/NewWorkspace.vue';
import JoinWorkspace from '@/views/components/workspace/JoinWorkspace.vue';
import Members from '@/views/components/members/members.vue';
import EmailForm from '@/views/widgets/form/EmailForm.vue';
import PasswordForm from '@/views/widgets/form/PasswordForm.vue';
import SplitPanes from './views/pages/SplitPanes.vue';
import WorkspaceDashboard from '@/views/components/workspace/WorkspaceDashboard.vue';
import UserInviteFormVue from './views/widgets/UserInviteForm.vue';
import UserSignIn from './views/pages/UserSignIn.vue';
import LandingPage from './views/components/landingPage/landingPage.vue';
import Chat from './views/pages/Chat.vue';

const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    { path: '/404', component: Error404 },
    { path: '/:catchAll(.*)', redirect: '/404' },
    {
      path: '/new_workspace',
      component: NewWorkspace,
      name: 'new_workspace',
      meta: { auth: true },
    },
    {
      path: '/join_workspace/:workspace_id',
      component: JoinWorkspace,
      name: 'join_workspace',
      meta: { auth: true },
    },
    {
      path: '/members',
      component: Members,
      name: 'members',
      meta: { auth: true },
    },
    {
      path: '/invite_user',
      component: EmailForm,
      name: 'invite_user',
      meta: { auth: true },
    },
    {
      path: '/password_form',
      component: PasswordForm,
      name: 'password_form',
      meta: { auth: true },
    },
    {
      path: '/',
      component: SplitPanes,
      name: 'screen',
      meta: { auth: true },
      children: [
        {
          path: '/screen/invite_to_workspace/:id',
          component: UserInviteFormVue,
          name: 'user_invite_form',
          meta: { auth: true },
        },
        {
          path: '',
          component: LandingPage,
          name: 'landing_page',
        },
        {
          path: '/users/:id',
          component: Chat,
          name: 'channel-chat',
        },
        {
          path: '/channels/:id',
          component: Chat,
          name: 'user-chat',
        },
        {
          path: '/groups/:id',
          component: Chat,
          name: 'group-chat',
        },
      ],
    },
    {
      path: '/workspace_dashboard',
      component: WorkspaceDashboard,
      name: 'workspace_dashboard',
      meta: { auth: true },
    },
    {
      path: '/sign_in/',
      component: UserSignIn,
      name: 'user_sign_in',
      meta: { auth: false },
    },
  ],
});
router.beforeEach((to, from, next) => {
  if (!sessionStorage.getItem('token') && to.meta.auth) {
    next('/sign_in');
  } else if (sessionStorage.getItem('token') && !to.meta.auth) {
    next('/');
  } else {
    next();
  }
});

export default router;
