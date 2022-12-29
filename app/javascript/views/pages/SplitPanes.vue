<template>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <div class="bg-primary text-sm h-screen flex flex-col ">
    <div class=" ">
      <SearchBar />
    </div>
    <splitpanes>
      <pane max-size="20" min-size="10">
        <WorkspaceDropdown title="BenchIT" :items="options" />
        <LeftPane />
      </pane>
      <pane class="bg-white " max-size="90" min-size="80">
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
    <UserInviteModal v-model:show="showModal"/>
  </div>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import WorkspaceDropdown from '../widgets/WorkspaceDropdown.vue';
import SearchBar from '../shared/searchBar.vue';
import Chat from './Chat.vue';
import 'splitpanes/dist/splitpanes.css';
import LeftPane from '../components/leftPane/LeftPane.vue';
import Thread from '../components/rightPane/Thread.vue';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import UserProfile from '../components/rightPane/UserProfile.vue';
import { useThreadStore } from '../../stores/useThreadStore';
import { userSignOut } from '../../api/user_auth/user_sign_out_api';
import { useSelectedScreenStore } from '../../stores/useSelectedScreen';
import searchDmscreen from '../components/directMessages/findDirectMessages.vue';
import UserInviteModal from '../widgets/userInviteModal.vue'

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
    enableInviteModal() {
      this.showModal = true;
    },
    sign_out() {
      let token = sessionStorage.getItem('token');
      userSignOut(token).then(res => {
        this.response = res;
        this.$router.push('/sign_in');
      });
    },
  },
  beforeUnmount() {
    this.options = null;
  },
  data() {
    return {
      modalOpen: false,
      UserInviteFormFlag: false,
      response: null,
      showModal: false,
      options: [
        {
          title: 'BenchIT',
          link: '#',
        },
        {
          title: 'Terms & Conditions',
          link: '#',
        },
        {
          title: 'Invite People',
          func: this.enableInviteModal,
        },
        {
          title: 'Create Channel',
          link: '#',
        },
        {
          title: 'Preferences',
          link: '#',
        },
        {
          title: 'Administration',
          link: '#',
        },
        {
          title: 'Tools',
          link: '#',
        },
        {
          title: 'Sign in to BenchIT on mobile',
          link: '#',
        },
        {
          title: 'Sign Out of BenchIT',
          func: this.sign_out,
        },
      ],
    };
  },
};
</script>
