import { createApp } from 'vue';
const app = createApp(Layout);

import './application.scss';

import Router from '@/routes.js';
import Layout from '@/views/shared/layout.vue';
import Axios from 'axios';

// ActionCable setup
import { createCable } from '@/plugins/cable';
const Cable = createCable({ channel: 'ChatChannel' });

// From animations + Axios
import { createApi } from '@/plugins/api';
const Api = createApi({ handler: Axios, namespace: '' });

// Pinia + Axios setup
import { createPinia } from 'pinia';
const Pinia = createPinia();
Pinia.use(({ store }) => {
  store.axios = Axios;
});

/* import the fontawesome core */
import { library } from '@fortawesome/fontawesome-svg-core';

/* import font awesome icon component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

/* import specific icons */
import {
  faIcons,
  faSquareCheck,
  faThumbsUp,
  faHeart,
  faShare,
  faCommentDots,
  faBookmark,
  faEllipsisVertical,
  faFaceSmile,
} from '@fortawesome/free-solid-svg-icons';

/* add icons to the library */
library.add(
  faIcons,
  faSquareCheck,
  faThumbsUp,
  faHeart,
  faShare,
  faCommentDots,
  faBookmark,
  faEllipsisVertical,
  faFaceSmile
);

// I18n loader
import { createI18n } from 'vue-i18n'; // Need the /index to avoid warning in console
const I18n = createI18n({ locale: 'current', messages: translations });

app
  .use(Router)
  .use(Pinia)
  .use(I18n)
  .use(Api)
  .use(Cable)
  .component('font-awesome-icon', FontAwesomeIcon)
  .mount('#app');
