import Splitscreen from './Splitscreen.vue';
import { frontendURL } from '../../helper/URLHelper';

export default {
  routes: [
    {
      path: frontendURL('screen'),
      name: 'screen',
      component: Splitscreen,
    },
  ],
};
