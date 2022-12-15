<template>
  <div class="bg-primary text-sm">
    <div class="border-b border-slate-400 bg-secondary">
      <SearchBar />
    </div>
    <splitpanes>
      <pane max-size="25" min-size="11">
        <WorkspaceDropdown title="BenchIT" :items="options" />
        <LeftPane />
      </pane>
      <pane max-size="70" min-size="75" class="bg-white">
        <router-view :key="$route.fullPath" />
      </pane>
      <div v-if="UserInviteFormFlag" class="modal-styling">
        <UserInviteFormVue :close-modal="closeForm" />
      </div>
      <pane
        v-if="threadStore.showThread"
        max-size="60"
        min-size="40"
        class="bg-white"
      >
        <Thread />
      </pane>
    </splitpanes>
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
import UserInviteFormVue from '../widgets/UserInviteForm.vue';
import { useThreadStore } from '../../stores/useThreadStore';
import { userSignOut } from '../../api/user_auth/user_sign_out_api';
import { useSelectedScreenStore } from '../../stores/useSelectedScreen';
import searchDmscreen from '../components/directMessages/findDirectMessages.vue';
export default {
  components: {
    Splitpanes,
    Pane,
    Chat,
    WorkspaceDropdown,
    LeftPane,
    UserInviteFormVue,
    Thread,
    searchDmscreen,
    SearchBar,
  },
  setup() {
    const screenStore = useSelectedScreenStore();
    const threadStore = useThreadStore();
    return { screenStore, threadStore };
  },
  methods: {
    closeForm() {
      this.UserInviteFormFlag = !this.UserInviteFormFlag;
    },
    enableInviteModal() {
      this.UserInviteFormFlag = !this.UserInviteFormFlag;
      this.$router.push({
        name: 'user_invite_form',
        params: { id: 1 },
      });
    },
    sign_out() {
      let token = sessionStorage.getItem('token');
      userSignOut(token).then(res => {
        this.response = res;
        this.$router.push('/sign_in');
      });
    },
  },
  data() {
    return {
      modalOpen: false,
      UserInviteFormFlag: false,
      response: null,
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

<style>
.chatpane {
  overflow: hidden;
  position: relative;
}

.modal-styling {
  background-color: transparent;
  margin-left: 40%;
  margin-top: 7%;
  position: absolute;
}
</style>
