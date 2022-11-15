<template>
  <splitpanes class="default-theme splitpanes">
    <pane
      max-size="33"
      min-size="10.45"
      style="background-color: #3f0e40;"
    ><LeftPane /></pane>
    <pane class="chatpane" max-size="100" min-size="67">
      <Chat />
    </pane>
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';

import Chat from '../components/chatPane/Chat.vue';
import Editor from '@tinymce/tinymce-vue';
import LeftPane from './LeftPane.vue';
export default {
  components: {
    Splitpanes,
    Pane,
    Chat,
    editor: Editor,
    LeftPane,
  },
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
