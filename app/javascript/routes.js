import { createWebHistory, createRouter } from 'vue-router';
import Error404 from '@/views/pages/error_404.vue';
import AllChannels from './views/pages/AllChannels.vue';
import NewWorkspace from '@/views/components/workspace/NewWorkspace.vue';
import JoinWorkspace from '@/views/components/workspace/JoinWorkspace.vue';
import Members from '@/views/components/members/members.vue';
import AllSearches from '@/views/components/search/AllSearches.vue';
import EmailForm from '@/views/widgets/form/EmailForm.vue';
import PasswordForm from '@/views/widgets/form/PasswordForm.vue';
import WorkspaceDashboard from '@/views/components/workspace/WorkspaceDashboard.vue';
import UserSignIn from './views/pages/UserSignIn.vue';
import UserSignUp from './views/pages/UserSignUp.vue';
import LandingPage from './views/components/landingPage/landingPage.vue';
import Chat from './views/pages/Chat.vue';
import Homepage from './views/pages/Homepage.vue';
import DraftsAndSentMessages from '@/views/components/draftsAndSent/DraftsAndSentMessages.vue';
import DraftMessages from './views/components/draftsAndSent/DraftMessages.vue';
import RecentlySentMessages from '@/views/components/draftsAndSent/RecentlySentMessages.vue';
import SaveMessageBody from './views/components/savemessages/SaveMessageBody.vue';
import ScheduleMessages from './views/components/schedule/ScheduleMessages.vue';
import { useCurrentProfileStore } from './stores/useCurrentProfileStore.js';
import { useCurrentUserStore } from './stores/useCurrentUserStore.js';
import { useCurrentWorkspaceStore } from './stores/useCurrentWorkspaceStore.js';
import DirectMessages from './views/components/directMessages/directMessages.vue';
import Threads from './views/pages/Threads.vue';
import { decryption } from './modules/crypto/crypto';
import { checkAuth } from './api/user_auth/check_auth';
import MentionsAndReactions from './views/components/mentionsAndReactions/MentionsAndReactions.vue';

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
          path: '/search',
          component: AllSearches,
          name: 'search',
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
          path: '/threads',
          component: Threads,
          name: 'threads',
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
          path: '/direct_messages',
          component: DirectMessages,
          name: 'direct-messages',
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
              path: '/drafts_sent_messages',
              component: DraftMessages,
              name: 'draft-messages',
              meta: {
                auth: true,
              },
            },
            {
              path: '/recently_sent_messages',
              component: RecentlySentMessages,
              name: 'recently-sent-messages',
              meta: {
                auth: true,
              },
            },
            {
              path: '/schedule_messages',
              component: ScheduleMessages,
              name: 'schedule-messages',
              meta: {
                auth: true,
              },
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
        {
          path: '/mentions_and_reactions',
          component: MentionsAndReactions,
          name: 'mentions-and-reactions',
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
    {
      path: '/sign_up/',
      component: UserSignUp,
      name: 'user_sign_up',
      meta: {
        auth: false,
      },
    }
  ],
});
router.beforeEach(async (to, from, next) => {
  const currentUserStore = useCurrentUserStore();
  const currentProfileStore = useCurrentProfileStore();
  const currentWorkspaceStore = useCurrentWorkspaceStore();

  const currentUser = decryption(localStorage, 'currentUser');
  const currentWorkspace = decryption(sessionStorage, 'currentWorkspace');
  const currentProfile = decryption(sessionStorage, 'currentProfile');

  currentProfileStore.setProfile({
    profile: currentProfile,
  });
  currentUserStore.setUser(currentUser);
  currentWorkspaceStore.setWorkspace(currentWorkspace);

  let authStatus = await checkAuth();

  if (to.path !== '/sign_in') {
    if (!authStatus) {
      localStorage.clear();
      sessionStorage.clear();
      next({ path: '/sign_in', replace: true });
    } else if (
      (!localStorage.getItem('token') && !currentWorkspace && to.meta.auth) ||
      !authStatus
    ) {
      next('/sign_in');
    } else if (
      (localStorage.getItem('token') && !currentWorkspace && to.meta.auth) ||
      !authStatus
    ) {
      next('/workspace_dashboard');
    } else if (
      localStorage.getItem('token') &&
      currentWorkspace &&
      !to.meta.auth &&
      !authStatus
    ) {
      next('/');
    } else {
      next();
    }
  }
  next();
});

export default router;
