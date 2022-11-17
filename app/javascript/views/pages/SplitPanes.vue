<template>
  <splitpanes class="default-theme splitpanes">
    <pane
      max-size="33"
      min-size="10.45"
      style="background-color: #3f0e40"
    >
    <WorkspaceDropdown title="BenchIT" :items="options" />
  </pane>
    <pane class="chatpane" max-size="100" min-size="67">
      <Chat />
    </pane>
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import WorkspaceDropdown from '../components/WorkspaceDropdown.vue'
import Chat from '../components/chatPane/Chat.vue';
export default {
  components: {
    Splitpanes,
    Pane,
    Chat,
    WorkspaceDropdown,
  },
  data () {
    return {
      options: [
        {
          title: 'BenchIT',
          link: '#'
        },
        {
          title: 'Terms & Conditions',
          link:'#'
        },
        {
          title: 'Invite People',
          link: '/invite_to_workspace/:id'
        },
        {
          title: 'Create Channel',
          link: '#'
        },
        {
          title: 'Preferences',
          link: '#'
        },
        {
          title: 'Administration',
          link: '#'
        },
        {
          title: 'Tools',
          link: '#'
        },
        {
          title: 'Sign in to BenchIT on mobile',
          link: '#'
        },
        {
          title: 'Sign Out of BenchIT',
          link: '#'
        }
      ]
    }
  }

};
</script>

<style scoped>
.splitpanes {
  height: 89vh;
  margin-top: -5%;
}
.chatpane {
  overflow: hidden;
  position: relative;
}
</style>
