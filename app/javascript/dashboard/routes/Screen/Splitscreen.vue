<template>
  <splitpanes class="default-theme" vertical style="height:100rem">
    <pane max-size="33" style="background-color: lightblue;" />
    <pane max-size="100" min-size="67" />
  </splitpanes>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';

export default {
  components: { Splitpanes, Pane },
};
</script>
