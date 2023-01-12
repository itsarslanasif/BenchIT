<template>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <div class="bg-primary text-sm h-screen flex flex-col">
    <div>
      <SearchBar />
    </div>
    <splitpanes @resize="resizePane">
      <pane
        max-size="20"
        size="15"
        min-size="10"
        v-if="leftPaneStore.getLeftpaneFlag"
      >
        <LeftPane />
      </pane>
      <pane class="bg-white" max-size="100" min-size="80">
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
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';

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
  methods: {
    resizePane(panes) {
      if (panes[0].size < 11) {
        this.leftPaneStore.closeLeftPane();
      }
    },
  },
  setup() {
    const screenStore = useSelectedScreenStore();
    const rightPaneStore = useRightPaneStore();
    const leftPaneStore = useLeftpaneStore();
    return { screenStore, rightPaneStore, leftPaneStore };
  },
};
</script>

<style>
.splitpanes__splitter {
  background-color: #ccc;
  position: relative;
}
.splitpanes__splitter:before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  transition: opacity 0.4s;
  background-color: #475569;
  opacity: 0;
  z-index: 1;
}
.splitpanes__splitter:hover:before {
  opacity: 1;
}
.splitpanes--vertical > .splitpanes__splitter:before {
  left: -5px;
  right: -5px;
  height: 100%;
}
.splitpanes--horizontal > .splitpanes__splitter:before {
  top: -30px;
  bottom: -30px;
  width: 100%;
}
</style>
