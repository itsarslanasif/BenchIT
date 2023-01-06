<template lang="">
  <div>
    <SplitPanesVue />
  </div>
</template>
<script>
import SplitPanesVue from './SplitPanes.vue';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { storeToRefs } from 'pinia';
import {
  createNotificationCable,
  unsubscribeNotification,
} from '../../plugins/cable';
export default {
  components: {
    SplitPanesVue,
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
      console.log(data);
      // cableActions(data.message);
    });
  },
  setup() {
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const currentProfileStore = useCurrentProfileStore();
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    const { currentProfile } = storeToRefs(currentProfileStore);
    return {
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
