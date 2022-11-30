<template>
  <div v-if="pinnedConversationStore.getCount>0" class=" container  text-xs bg-inherit mr-1 hover:text-white hover:bg-slate-900 rounded-lg">
   <span class="p-1">&#128204; {{pinnedConversationStore.getCount}} Pinned </span>
  </div>
</template>

<script>
import { CONSTANTS } from '../../../assets/constants';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
export default {
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return {pinnedConversationStore };
  },
  data() {
    return {
      CONSTANTS: CONSTANTS,
    };
  },
  methods: {
    handleSave(event) {
      // this.$emit('clicked', this.bookmark);
    },
  },
};
</script>

<style scoped>
.container{
  height: 22px;
}

</style>
