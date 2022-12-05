<template>
  <div v-if="pinnedConversationStore.getCount > 0">
    <button
      @click="pinnedConversationStore.togglePin()"
      class="text-xs hover:text-white hover:bg-primary hover:border-transparent text-slate-1000 font-bold py-2 px-4 rounded-md border-white"
    >
      &#128204;
      {{ pinnedConversationStore.getCount }}
      {{ $t('pinconversation.pinned') }}
    </button>
  </div>
</template>

<script>
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
export default {
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
  },
};
</script>
