<template>
  <div class="justify-content-center items-center">Direct Messages</div>
</template>

<script>
import { storeToRefs } from 'pinia';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import {
  getDirectMessagesList,
  getLastDirectMessagesList,
} from '../../../api/directMessages/directMessages';
export default {
  setup() {
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    return { currentWorkspace };
  },
  async mounted() {
    const dmList = await getDirectMessagesList(this.currentWorkspace.id);
    const dmIDs = dmList.map(dm => dm.id);
    const last_messages = await getLastDirectMessagesList(dmIDs);
    console.log(last_messages);
  },
};
</script>
