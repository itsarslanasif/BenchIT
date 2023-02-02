<template>
  <div v-show="false" class="testing bg-slate-500"></div>
</template>

<script>
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { NModal } from 'naive-ui';
export default {
  props: ['show'],
  components: {
    NModal
  },
  setup() {
    const fileStore = useRecentFilesStore();
    return {
      fileStore,
    };
  },
};
</script>

<style scoped>
.testing {
  width: 500px;
  height: 400px;
}
</style>
