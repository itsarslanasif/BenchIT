<template>
  <div
    v-show="pinnedConversationStore.pinToggle"
    class="flex overflow-auto z-10 px-2 py-2 flex-col bg-slate-900 rounded-lg bb"
  >
    <template
      v-for="message in pinnedConversationStore.getPinnedConversation"
      :key="message.id"
    >
      <div class="mt-5">
        <MessageWrapper :curr-message="message" :prev-message="prevMessage" />
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
.bb {
  width: 500px;
  position: fixed;
  max-height: 300px;
}
</style>
