<template>
  <splitpanes class="default-theme">
    <pane max-size="33" min-size="10.45" style="background-color:#3f0e40;" />

    <pane max-size="100" min-size="67">
      <div>
        <Editor v-model="content" />
        <textarea v-model="content" />
      </div>
    </pane>
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import Editor from './Editor.vue';

export default {
  components: {
    Splitpanes,
    Pane,
    Editor,
  },
};
</script>

<style>
splitpanes {
  height: 100vh;
}
</style>
