<template>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <div class="bg-primary text-sm h-screen flex flex-col">
    <div class=" ">
      <SearchBar />
    </div>
    <splitpanes>
      <pane max-size="35" min-size="15">
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
  },
  setup() {
    const screenStore = useSelectedScreenStore();
    const rightPaneStore = useRightPaneStore();
    return { screenStore, rightPaneStore };
  },
  methods: {
    beforeUnmount() {
      this.options = null;
    },
  },
  data() {
    return {
      response: null,
    };
  },
};
</script>
