<template>
  <div class="bg-primary text-sm">
    <splitpanes>
      <pane max-size="25" min-size="11">
        <WorkspaceDropdown title="BenchIT" :items="options" />
        <LeftPane />
      </pane>
      <pane max-size="81" min-size="75" class="bg-white">
        <Chat v-show="screenStore.getSekectedScreen=='chat'" />
        <searchDmscreen v-show="screenStore.getSekectedScreen=='search-dm'" />
      </pane>
      <div v-if="UserInviteFormFlag" class="modal-styling">
        <UserInviteFormVue :close-modal="closeForm" />
      </div>
    </splitpanes>
  </div>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import WorkspaceDropdown from '../widgets/WorkspaceDropdown.vue';
import Chat from './Chat.vue';
import 'splitpanes/dist/splitpanes.css';
import LeftPane from '../components/leftPane/LeftPane.vue';
import UserInviteFormVue from '../widgets/UserInviteForm.vue';
import { useSelectedScreenStore } from '../../stores/userSelectedScreen';
import searchDmscreen from '../components/directMessages/findDirectMessages.vue'
export default {
  components: {
    Splitpanes,
    Pane,
    Chat,
    WorkspaceDropdown,
    LeftPane,
    UserInviteFormVue,
    searchDmscreen,
  },
  setup() {
    const screenStore = useSelectedScreenStore();
    return { screenStore };
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
  },
  data() {
    return {
      modalOpen: false,
      UserInviteFormFlag: false,
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
          link: '#',
        },
      ],
    };
  },
};
</script>

<style>
/* .splitpanes {
  height: 89vh;
} */

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
