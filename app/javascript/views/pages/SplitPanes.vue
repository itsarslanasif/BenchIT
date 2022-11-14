<template>

  <splitpanes class="default-theme">
    <pane max-size="33" min-size="10.45" style="background-color: #3f0e40">
      <div>
        <CreateChannelVue/>
        <button class="btn" @click="modalOpen = !modalOpen">Open Modal</button>
        <div v-if="modalOpen">
          <CreateChannel :closeModal="closeModal"/>
        </div>
      </div>
    </pane>

    <pane max-size="100" min-size="67">
      <div class="editor">
        <editor
          api-key="v69g5pnxcpt0m2kmjntucft1sek0y2g7qw17n2scwu0pi76w"
          :init="{
            menubar: false,
            statusbar: false,
            plugins: 'lists link code',
            toolbar:
              'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code',
          }"
        />
      </div>
    </pane>
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import CreateChannel from '../containers/CreateChannel.vue';

import Chat from '../components/chatPane/Chat.vue';
import 'splitpanes/dist/splitpanes.css';
export default {
  components: {
    Splitpanes,
    Pane,
    CreateChannel,
    Chat,
  },
  data() {
      return {
        modalOpen: false
      }
    },
    methods: {
      closeModal() {
        this.modalOpen = !this.modalOpen;
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
