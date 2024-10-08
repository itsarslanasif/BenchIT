<template>
  <n-message-provider placement="top-right">
    <div class="relative bg-primary text-sm h-screen grid grid-container">
      <alert v-if="downloadsStore.downloadAlert" />
      <switching-workspace-loader
        v-if="currentWorkspaceStore.switchingWorkspace"
      />
      <div class="header">
        <SearchBar />
      </div>
      <splitpanes @resize="resizePane">
        <pane
          max-size="30"
          :size="isMobileView() ? '300px' : 15"
          :class="isMobileView() ? 'relative z-10' : ''"
          min-size="10"
          v-if="leftPaneStore.getLeftpaneFlag"
        >
          <LeftPane />
        </pane>
        <pane
          class="bg-white"
          max-size="100"
          min-size="80"
          :class="
            leftPaneStore.getLeftpaneFlag && isMobileView() ? 'hidden' : ''
          "
        >
          <router-view :key="$route.fullPath" />
        </pane>
        <pane
          v-if="rightPaneStore.showThread || rightPaneStore.showUserProfile"
          max-size="60"
          min-size="40"
          class="bg-white"
          :class="
            leftPaneStore.getLeftpaneFlag && isMobileView() ? 'hidden' : ''
          "
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
import { onMounted, onUnmounted } from 'vue';
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
import SwitchingWorkspaceLoader from '../components/workspace/SwitchingWorkspaceLoader.vue';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { NMessageProvider, useMessage } from 'naive-ui';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
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
    SearchBar,
    UserProfile,
    SwitchingWorkspaceLoader,
    NMessageProvider,
    NMessageProvider,
    alert,
  },
  data() {
    return {
      screenSize: 0,
    };
  },
  methods: {
    resizePane(panes) {
      if (panes[0].size < 13) {
        this.leftPaneStore.closeLeftPane();
      }
    },
    updateScreenWidth() {
      this.screenSize = window.innerWidth;
      this.startView();
    },
    isMobileView() {
      return this.screenSize < 500 && this.screenSize > 0;
    },
    startView() {
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      } else {
        this.leftPaneStore.openLeftPane();
      }
    },
  },
  mounted() {
    this.screenSize = window.innerWidth;
    this.startView();
    window.addEventListener('resize', this.updateScreenWidth);
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.updateScreenWidth);
  },
  setup() {
    const screenStore = useSelectedScreenStore();
    const rightPaneStore = useRightPaneStore();
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const leftPaneStore = useLeftpaneStore();
    const downloadsStore = useDownloadsStore();

    onMounted(() => {
      window.addEventListener('resize', handleResize);
      handleResize();
    });

    onUnmounted(() => {
      window.removeEventListener('resize', handleResize);
    });

    const handleResize = () => {
      const height = window.innerHeight - 44;
      const splitpanes = document.getElementsByClassName('splitpanes');
      splitpanes[0].style.height = `${height}px`;
    };
    window.$message = useMessage();

    return {
      screenStore,
      rightPaneStore,
      leftPaneStore,
      currentWorkspaceStore,
      downloadsStore,
    };
  },
};
</script>

<style>
.splitpanes {
  grid-area: main;
}
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
.splitpanes__pane {
  display: flex;
  flex-direction: column;
  height: 100%;
  grid-area: main;
}
.grid-container {
  grid-auto-rows: 44px auto;
  grid-template-columns: 1fr 2fr;
  grid-template-areas:
    'header header '
    'main main ';
}
.header {
  grid-area: header;
}
.main {
  grid-area: main;
}
.sidebar {
  grid-area: sidebar;
}
</style>
