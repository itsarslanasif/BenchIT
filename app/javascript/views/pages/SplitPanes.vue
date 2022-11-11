<template>
  <splitpanes class="default-theme">
    <pane max-size="33" min-size="10.45" style="background-color: #3f0e40" />

    <pane max-size="100" min-size="67">
      <Chat />
    </pane>
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import Chat from '../components/chatPane/Chat.vue';

export default {
  components: { Splitpanes, Pane, Chat },
};
</script>

<style scoped>
splitpanes {
  height: 100vh;
}
</style>
