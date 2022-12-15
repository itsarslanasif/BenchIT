<template>
  <div v-if="pinnedConversationStore.getCount > 0">
    <div
      @click="pinnedConversationStore.togglePin()"
      class="border flex content-center border-transparent text-xs px-2 py-1 mr-2 overflow-auto rounded-md text-black-600 hover:text-primary hover:bg-transparent w-max inline-block">
      <span class="px-1"
        ><font-awesome-icon icon="fa-solid fa-thumbtack" />
      </span>
      <span class="px-1">{{ pinnedConversationStore.getCount }}</span>
      <span> {{ $t('pinconversation.pinned') }} </span>
    </div>
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
