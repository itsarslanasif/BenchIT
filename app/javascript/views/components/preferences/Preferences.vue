<template>
  <n-card :title="$t('preferences.title')" class="w-1/2">
    <div class="flex  overflow-y-scroll">
      <div class="w-1/4">
        <div
          v-for="item of options"
          :key="item"
          @click="enableComponent(item)"
          class="hover:text-white px-4 py-1 my-1 rounded cursor-pointer"
          :class="item == selectedItem ? 'bg-primary text-white hover:bg-primary' : ' hover:bg-primaryHover'"
        >
          {{ item.title }}
        </div>
      </div>
      <div class="w-3/4 px-5 custom-height">
        <Notification v-if="options.notification.flag" />
        <Sidebar v-if="options.sidebar.flag" />
        <Themes v-if="options.themes.flag" />
        <MessagesMedia v-if="options.messagesMedia.flag" />
        <LanguageRegion v-if="options.languageRegion.flag" />
        <Accessibility v-if="options.accessibility.flag" />
        <MarkAsRead v-if="options.markAsRead.flag" />
        <AudioVideo v-if="options.audioVideo.flag" />
        <ConnectedAccounts v-if="options.connectedAccounts.flag" />
        <PrivacyVisibility v-if="options.privacyVisibility.flag" />
        <Advanced v-if="options.advanced.flag" />
      </div>
    </div>
  </n-card>
</template>

<script>
import { NCard } from 'naive-ui';
import Notification from './Notification.vue'
import Sidebar from './Sidebar.vue'
import Themes from './Themes.vue'
import MessagesMedia from './MessagesMedia.vue'
import LanguageRegion from './LanguageRegion.vue'
import Accessibility from './Accessibility.vue'
import MarkAsRead from './MarkAsRead.vue'
import AudioVideo from './AudioVideo.vue'
import ConnectedAccounts from './ConntectedAccounts.vue'
import PrivacyVisibility from './PrivacyVisibility.vue'
import Advanced from './Advanced.vue'
export default {
  components: {
    NCard,
    Notification,
    Sidebar,
    Themes,
    MessagesMedia,
    LanguageRegion,
    Accessibility,
    MarkAsRead,
    AudioVideo,
    ConnectedAccounts,
    PrivacyVisibility,
    Advanced
  },
  data() {
    return {
      selectedItem: null,
      options: {
        notification: {
          title: 'Notification',
          key: 'notification',
          flag: true,
        },
        sidebar: {
          title: 'Sidebar',
          key: 'sidebar',
          flag: false,
        },
        themes: {
          title: 'Themes',
          key: 'themes',
          flag: false,
        },
        messagesMedia: {
          title: 'Messages & Media',
          key: 'messagesMedia',
          flag: false,
        },
        languageRegion: {
          title: 'Language & Region',
          key: 'languageRegion',
          flag: false,
        },
        accessibility: {
          title: 'Accessibility',
          key: 'accessibility',
          flag: false,
        },
        markAsRead: {
          title: 'Mark as read',
          key: 'markAsRead',
          flag: false,
        },
        audioVideo: {
          title: 'Audio & Video',
          key: 'audioVideo',
          flag: false,
        },
        connectedAccounts: {
          title: 'Connected Accounts',
          key: 'connectedAccounts',
          flag: false,
        },
        privacyVisibility: {
          title: 'Privacy & Visibility',
          key: 'privacyVisibility',
          flag: false,
        },
        advanced: {
          title: 'Advanced',
          key: 'advanced',
          flag: false,
        },
      },
    };
  },
  methods: {
    enableComponent(item) {
      Object.values(this.options).map(k => {
        k.flag = false;
      });
      this.options[item.key].flag = true;
      this.selectedItem = item
    },
  },
};
</script>

<style>
.custom-height {
  height: 650px;
}
</style>
