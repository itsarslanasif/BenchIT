<template>
  <splitpanes class="default-theme">
    <pane max-size="33" min-size="10.45" style="background-color:#3f0e40;">
      <Leftpane />
    </pane>

    <pane max-size="100" min-size="67" />
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';

import Leftpane from './Leftpane.vue';

export default {
  components: { Splitpanes, Pane, Leftpane },
};
</script>

<style>
splitpanes {
  height: 100vh;
}
</style>
