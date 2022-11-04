// import { createRouter, createWebHistory } from 'vue-router';
import NameForm from './NameForm.vue';
import { frontendURL } from '../../helper/URLHelper';
import PasswordForm from './PasswordForm.vue';
import WorkspaceInfo from './WorkspaceInfo.vue';
import CompanyInfo from './CompanyInfo.vue';
import WorkspaceURL from './WorkspaceURL.vue';

export default {
  routes: [
    {
      path: frontendURL('name_form'),
      name: 'name_form',
      component: NameForm,
    },
    {
      path: frontendURL('password_form'),
      name: 'password_form',
      component: PasswordForm,
    },
    {
      path: frontendURL('workspace_info'),
      name: 'workspace_info',
      component: WorkspaceInfo,
    },
    {
      path: frontendURL('company_info'),
      name: 'company_info',
      component: CompanyInfo,
    },
    {
      path: frontendURL('workspace_url'),
      name: 'workspace_url',
      component: WorkspaceURL,
    },
  ],
};
