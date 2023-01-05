<template>
  <div
    v-if="pinnedConversationStore.pinToggle"
    class="flex overflow-auto z-10 px-2 py-2 ml-1 fixed flex-col border-slate-700 bg-slate-900 w-6/12 maxHeight border-2 rounded-lg"
  >
    <div class="w-100 flex justify-end">
      <span
        class="text-slate-400 text-xs rounded-lg cursor-pointer p-1"
        @click="pinnedConversationStore.togglePin"
      >
        X
      </span>
    </div>
    <template
      v-for="pin in pinnedConversationStore.getPinnedConversation"
      :key="pin.id"
    >
      <div class="mt-5">
        <MessageWrapper :curr-message="pin.message" :prev-message="prevMessage" />
      </div>
    </template>
  </div>
</template>
<script>
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import MessageWrapper from '../messages/MessageWrapper.vue';

export default {
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
  },
  components: {
    MessageWrapper,
  },
};
</script>

<style scoped>
.maxHeight {
  max-height: 300px;
}
</style>
