import { createWebHistory, createRouter } from 'vue-router';
import Error404 from '@/views/pages/error_404.vue';
import AllChannels from './views/pages/AllChannels.vue';
import NewWorkspace from '@/views/components/workspace/NewWorkspace.vue';
import JoinWorkspace from '@/views/components/workspace/JoinWorkspace.vue';
import Members from '@/views/components/members/members.vue';
import EmailForm from '@/views/widgets/form/EmailForm.vue';
import PasswordForm from '@/views/widgets/form/PasswordForm.vue';
import SplitPanes from './views/pages/SplitPanes.vue';
import WorkspaceDashboard from '@/views/components/workspace/WorkspaceDashboard.vue';
import UserSignIn from './views/pages/UserSignIn.vue';
import LandingPage from './views/components/landingPage/landingPage.vue';
import Chat from './views/pages/Chat.vue';
import Homepage from './views/pages/Homepage.vue';
import NewDirectMessages from '@/views/components/directMessages/findDirectMessages.vue';
import DraftsAndSentMessages from '@/views/components/draftsAndSent/DraftsAndSentMessages.vue';
import RecentlySentMessages from '@/views/components/draftsAndSent/RecentlySentMessages.vue';
import SaveMessageBody from './views/components/savemessages/SaveMessageBody.vue';
import { useCurrentProfileStore } from './stores/useCurrentProfileStore.js';
import { useCurrentUserStore } from './stores/useCurrentUserStore.js';
import { useCurrentWorkspaceStore } from './stores/useCurrentWorkspaceStore.js';
const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    {
      path: '/404',
      component: Error404,
    },
    {
      path: '/:catchAll(.*)',
      redirect: '/404',
    },
    {
      path: '/new_workspace',
      component: NewWorkspace,
      name: 'new_workspace',
      meta: {
        auth: true,
      },
    },
    {
      path: '/join_workspace/:workspace_id',
      component: JoinWorkspace,
      name: 'join_workspace',
      meta: {
        auth: true,
      },
    },
    {
      path: '/invite_user',
      component: EmailForm,
      name: 'invite_user',
      meta: {
        auth: true,
      },
    },
    {
      path: '/password_form',
      component: PasswordForm,
      name: 'password_form',
      meta: {
        auth: true,
      },
    },
    {
      path: '/',
      component: Homepage,
      name: 'screen',
      meta: {
        auth: true,
      },
      children: [
        {
          path: '',
          component: LandingPage,
          name: 'landing_page',
        },
        {
          path: '/members',
          component: Members,
          name: 'members',
          meta: {
            auth: true,
          },
        },
        {
          path: '/profiles/:id/:message_id?',
          component: Chat,
          name: 'channel-chat',
        },
        {
          path: '/channels/:id/:message_id?',
          component: Chat,
          name: 'user-chat',
        },
        {
          path: '/browse-channels',
          component: AllChannels,
          name: 'browse-channels',
          meta: {
            auth: true,
          },
        },
        {
          path: '/groups/:id/:message_id?',
          component: Chat,
          name: 'group-chat',
        },
        {
          path: '/new_direct_message',
          component: NewDirectMessages,
          name: 'new-direct-message',
        },
        {
          path: '/drafts_sent_messages',
          component: DraftsAndSentMessages,
          name: 'drafts-sent-messages',
          meta: {
            auth: true,
          },
          children: [
            {
              path: '/recently_sent_messages',
              component: RecentlySentMessages,
              name: 'recently-sent-messages',
            },
          ],
        },
        {
          path: '/savemessages',
          component: SaveMessageBody,
          name: 'savemessage',
          meta: {
            auth: true,
          },
        },
      ],
    },
    {
      path: '/workspace_dashboard',
      component: WorkspaceDashboard,
      name: 'workspace-dashboard',
      meta: {
        auth: false,
      },
    },
    {
      path: '/sign_in/',
      component: UserSignIn,
      name: 'user_sign_in',
      meta: {
        auth: false,
      },
    },
  ],
});
router.beforeEach((to, from, next) => {
  const currentUserStore = useCurrentUserStore();
  const currentProfileStore = useCurrentProfileStore();
  const currentWorkspaceStore = useCurrentWorkspaceStore();

  const currentWorkspace = JSON.parse(
    sessionStorage.getItem('currentWorkspace')
  );
  const currentProfile = JSON.parse(sessionStorage.getItem('currentProfile'));
  const currentUser = JSON.parse(localStorage.getItem('currentUser'));

  currentProfileStore.setProfile({
    profile: currentProfile,
  });
  currentUserStore.setUser(currentUser);
  currentWorkspaceStore.setWorkspace(currentWorkspace);

  if (
    !localStorage.getItem('token') &&
    currentWorkspace === null &&
    to.meta.auth
  ) {
    next('/sign_in');
  } else if (
    localStorage.getItem('token') &&
    currentWorkspace === null &&
    to.meta.auth
  ) {
    next('/workspace_dashboard');
  } else if (
    localStorage.getItem('token') &&
    currentWorkspace !== null &&
    !to.meta.auth
  ) {
    next('/');
  } else {
    next();
  }
});

export default router;
