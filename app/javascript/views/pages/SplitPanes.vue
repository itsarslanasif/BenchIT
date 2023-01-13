<template>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <n-message-provider placement="top-right">
    <div class="relative bg-primary text-sm h-screen flex flex-col">
      <alert v-if="downloadsStore.downloadAlert" />
      <div>
        <SearchBar />
      </div>
      <splitpanes>
        <pane max-size="20" min-size="10">
          <WorkspaceDropdown />
          <LeftPane />
        </pane>
        <pane class="bg-white" max-size="90" min-size="80">
          <router-view :key="$route.fullPath" />
        </pane>
        <pane
          v-if="rightPaneStore.showThread || rightPaneStore.showUserProfile"
          max-size="80"
          min-size="60"
          class="bg-white"
        >
          <Thread
            v-if="rightPaneStore.showThread && !rightPaneStore.showUserProfile"
          />
          <UserProfile
            v-if="!rightPaneStore.showThread && rightPaneStore.showUserProfile"
          />
        </pane>
      </splitpanes>
    </div>
  </n-message-provider>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import WorkspaceDropdown from '../widgets/workspaceDropdown/WorkspaceDropdown.vue';
import SearchBar from '../shared/searchBar.vue';
import Chat from './Chat.vue';
import 'splitpanes/dist/splitpanes.css';
import LeftPane from '../components/leftPane/LeftPane.vue';
import Thread from '../components/rightPane/Thread.vue';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import UserProfile from '../components/rightPane/UserProfile.vue';
import { useSelectedScreenStore } from '../../stores/useSelectedScreen';
import searchDmscreen from '../components/directMessages/findDirectMessages.vue';
import { NMessageProvider } from 'naive-ui';
import { useDownloadsStore } from '../../stores/useDownloadsStore';
import alert from '../widgets/alert.vue';

export default {
  components: {
    Splitpanes,
    Pane,
    Chat,
    WorkspaceDropdown,
    LeftPane,
    Thread,
    searchDmscreen,
    SearchBar,
    UserProfile,
    NMessageProvider,
    alert,
  },
  setup() {
    const screenStore = useSelectedScreenStore();
    const rightPaneStore = useRightPaneStore();
    const downloadsStore = useDownloadsStore();
    return { screenStore, rightPaneStore, downloadsStore };
  },
};
</script>
