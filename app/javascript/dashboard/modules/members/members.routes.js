import { frontendURL } from '../../helper/URLHelper';
import members from './members.vue'

export default {
  routes: [
    {
      path: frontendURL('members'),
      name: 'members',
      component: members,
    },
  ],
};
