import { createWebHistory, createRouter } from 'vue-router'

import PageIndex from '@/views/pages/index.vue'
import Error404 from '@/views/pages/error_404.vue'
import SearchPage from '@/views/pages/search.vue'
import NewWorkspace from '@/modules/workspace/NewWorkspace.vue'
import JoinWorkspace from '@/modules/workspace/JoinWorkspace.vue'
import Members from '@/modules/members/members.vue'
import EmailForm from '@/modules/user/EmailForm.vue'
import PasswordForm from '@/modules/user/PasswordForm.vue'
import SplitPanes from './views/pages/SplitPanes.vue'
import WorkspaceDashboard from '@/modules/workspace/WorkspaceDashboard.vue'
import UserInviteFormVue from './views/components/UserInviteForm.vue'
import ChannelElement from './views/components/ChannelElement.vue'

const router = createRouter({
  history: createWebHistory(`/${I18n.prefix}`),
  routes: [
    { path: '/', component: PageIndex, name: 'root_path' },
    { path: '/search', component: SearchPage, name: 'search' },
    { path: '/404', component: Error404 },
    { path: '/:catchAll(.*)', redirect: '/404' },
    { path: '/new_workspace', component: NewWorkspace, name: 'new_workspace' },
    { path: '/join_workspace/:workspace_id', component: JoinWorkspace, name: 'join_workspace' },
    { path: '/members', component: Members, name: 'members' },
    { path: '/invite_user', component: EmailForm, name: 'invite_user' },
    { path: '/password_form', component: PasswordForm, name: 'password_form' },
    {
      path: '/screen', component: SplitPanes, name: 'screen',
      children: [
        {
          path: '/screen/invite_to_workspace/:id',
          component: UserInviteFormVue,
          name: 'user_invite_form'
        }
      ]
    },
    { path: '/workspace_dashboard', component: WorkspaceDashboard, name: 'workspace_dashboard' },
    { path: '/channel/:name', component: ChannelElement, name: 'channel-id' },
  ]
});

export default router
