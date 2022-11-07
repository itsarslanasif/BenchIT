<!-- eslint-disable vue/valid-template-root -->
<template>
  <div>
    <splitpanes class="default-theme" vertical style="height:100vh">
      <pane max-size="33" style="background-color: lightblue;" />
      <pane max-size="100" min-size="67" style="background-color: #FFFFFF">
        <div>
          <woot-message-editor
            class="editor"
            :placeholder="messagePlaceHolder"
          />
        </div>
      </pane>
    </splitpanes>
  </div>
</template>

<script>
import { Splitpanes, Pane } from 'splitpanes';
import 'splitpanes/dist/splitpanes.css';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor';

export default {
  components: {
    Splitpanes,
    Pane,
    WootMessageEditor,
  },
};
</script>

<style lang="scss" scoped>
.editor {
  border: 1px solid;
  border-color: rgb(212, 212, 212);
  margin-bottom: 0.5vh;
  margin-top: 100vh;
  padding-left: 2rem;
}
</style>
