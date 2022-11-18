<template>
  <splitpanes class="default-theme">
    <pane max-size="33" min-size="10.45" style="background-color: #3f0e40">
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
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import CreateChannel from '../containers/CreateChannel.vue';

import Chat from '../components/chatPane/Chat.vue';
import 'splitpanes/dist/splitpanes.css';
import LeftPane from '../components/LeftPane.vue';
import ChannelElement from '../components/ChannelElement.vue';
export default {
  components: {
    Splitpanes,
    Pane,
    CreateChannel,
    Chat,
    LeftPane,
    ChannelElement,
  },
  data() {
    return {
      modalOpen: false,
    };
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
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
</style>
