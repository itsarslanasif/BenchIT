<template>
  <div>
    <BenchITAlert :errorMessage = 'error' v-if="errorFlag" />
    <SplitPanesVue />
  </div>
</template>
<script>
import SplitPanesVue from './SplitPanes.vue';
import BenchITAlert  from '../widgets/benchitAlert.vue'
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { useMessageStore } from '../../stores/useMessagesStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useSavedItemsStore } from '../../stores/useSavedItemStore';
import { storeToRefs } from 'pinia';
import { useUnreadStore } from '../../stores/useUnreadStore';
import { notifyActions } from '../../modules/cable/notification';
import {
  createNotificationCable,
  unsubscribeNotification,
} from '../../plugins/cable';
export default {
  components: {
    SplitPanesVue,
    BenchITAlert,
  },
  data() {
    return {
      Cable: null,
      currentProfile: {},
      currentWorkspace: {},
    };
  },
  mounted() {
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
    };
  },
  beforeUnmount() {
    unsubscribeNotification();
    this.Cable = null;
  },
};
</script>
