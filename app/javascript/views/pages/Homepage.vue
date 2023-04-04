<template>
  <n-message-provider placement="top-right">
    <div>
      <SplitPanesVue />
    </div>
  </n-message-provider>
</template>
<script>
import SplitPanesVue from './SplitPanes.vue';
import { NMessageProvider } from 'naive-ui';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useSavedItemsStore } from '../../stores/useSavedItemStore';
import { storeToRefs } from 'pinia';
import { useUnreadStore } from '../../stores/useUnreadStore';
import { notifyActions } from '../../modules/cable/notification';
import { useConnectionStore } from '../../stores/useConnectionStore';
import {
  createNotificationCable,
  unsubscribeNotification,
} from '../../plugins/cable';
export default {
  components: {
    SplitPanesVue,
    NMessageProvider,
  },
  data() {
    return {
      Cable: null,
      currentProfile: {},
      currentWorkspace: {},
    };
  },
  beforeUnmount() {
    window.removeEventListener('online');
    window.removeEventListener('offline');
  },
  mounted() {
    window.addEventListener('online', () => {
      this.connectionStore.toggleConnection(true);
    });
    window.addEventListener('offline', () => {
      this.connectionStore.toggleConnection(false);
    });
    this.Cable = createNotificationCable({
      channel: 'NotificationChannel',
      workspace_id: this.currentWorkspace.id,
      profile_id: this.currentProfile.id,
    });
    this.Cable.on('notification', data => {
      notifyActions(data.message);
    });
  },
  setup() {
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const currentProfileStore = useCurrentProfileStore();
    const connectionStore = useConnectionStore();
    const savedItemStore = useSavedItemsStore();
    const unreadMessageStore = useUnreadStore();
    const messageStore = useMessageStore();
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    const { currentProfile } = storeToRefs(currentProfileStore);
    messageStore.getAllScheduleMessages();
    unreadMessageStore.index();
    savedItemStore.index();
    return {
      unreadMessageStore,
      currentWorkspace,
      currentProfile,
      connectionStore,
    };
  },
  beforeUnmount() {
    unsubscribeNotification();
    this.Cable = null;
  },
};
</script>

<style>
::-webkit-scrollbar {
  width: 5px;
}

::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px 475569;
  border-radius: 5px;
}

::-webkit-scrollbar-thumb {
  background: #475569;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: #475569;
}
</style>
