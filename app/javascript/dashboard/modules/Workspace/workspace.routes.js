import { frontendURL } from '../../helper/URLHelper';
import NewWorkspace from './NewWorkspace.vue';

export default {
  routes: [
    {
      path: frontendURL('new_workspace'),
      name: 'new_workspace',
      component: NewWorkspace,
    },
  ],
};
