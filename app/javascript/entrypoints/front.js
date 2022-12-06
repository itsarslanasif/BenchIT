import './application.scss';
import axios from 'axios';
import Router from '@/routes.js';
import Layout from '@/views/shared/layout.vue';
import { createApp } from 'vue';
import { createI18n } from 'vue-i18n';
import { createCable } from '@/plugins/cable';
import { createApi } from '@/plugins/api';
import { createPinia } from 'pinia';
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
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
  faHashtag,
  faUser,
  faLock,
  faThumbtack,
  faXmark
} from '@fortawesome/free-solid-svg-icons';
import '@fortawesome/fontawesome-free/css/all.css'
import '@fortawesome/fontawesome-free/js/all.js'
const Cable = createCable({ channel: 'ChatChannel' });
const app = createApp(Layout);
const Api = createApi({ handler: axios, namespace: '' });
const Pinia = createPinia();
Pinia.use(({ store }) => { store.axios = axios })
library.add(
  faIcons,
  faSquareCheck,
  faThumbsUp,
  faHeart,
  faShare,
  faCommentDots,
  faBookmark,
  faEllipsisVertical,
  faFaceSmile,
  faHashtag,
  faUser,
  faLock,
  faThumbtack,
  faXmark
);
const I18n = createI18n({ locale: 'current', messages: translations });

app.use(Router)
  .use(Pinia)
  .use(I18n)
  .use(Api)
  .use(Cable)
  .component('font-awesome-icon', FontAwesomeIcon)
  .mount('#app')
