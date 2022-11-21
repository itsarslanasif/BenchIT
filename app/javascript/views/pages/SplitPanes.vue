<template>
  <splitpanes class="default-theme">
    <pane max-size="33" min-size="10.45" style="background-color: #3f0e40">
      <WorkspaceDropdown title="BenchIT" :items="options" />
      <LeftPane />
      <div>
        <div class="modalStyle">
          <CreateChannelVue />
        </div>
        <button class="btn" @click="modalOpen = !modalOpen">Open Modal</button>
        <div v-if="modalOpen">
          <CreateChannel :close-modal="closeModal" />
        </div>
      </div>
    </pane>

    <pane max-size="100" min-size="67">
      <ChannelElement />
      <div class="modalBack"><Chat /></div>
    </pane>
    <div v-if="UserInviteFormFlag" class="modal-styling">
      <UserInviteFormVue :close-modal="closeForm"  />
    </div>
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import WorkspaceDropdown from '../components/WorkspaceDropdown.vue';
import CreateChannel from '../containers/CreateChannel.vue';
import Chat from '../components/chatPane/Chat.vue';
import 'splitpanes/dist/splitpanes.css';
import LeftPane from '../components/LeftPane.vue';
import ChannelElement from '../components/ChannelElement.vue';
import UserInviteFormVue from '../components/UserInviteForm.vue';
export default {
  components: {
    Splitpanes,
    Pane,
    CreateChannel,
    Chat,
    WorkspaceDropdown,
    LeftPane,
    ChannelElement,
    UserInviteFormVue,
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    closeForm() {
      this.UserInviteFormFlag= !this.UserInviteFormFlag;
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

<style scoped>
.splitpanes {
  height: 89vh;
}

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
