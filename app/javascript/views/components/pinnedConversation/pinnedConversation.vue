<template>
  <div v-if="pinnedConversationStore.getCount">
    <button
      @click="pinnedConversationStore.togglePin()"
      class="text-xs px-2 py-1 mb-1 mr-1 rounded-md text-black-600 hover:bg-transparent"
    >
      <font-awesome-icon icon="fa-solid fa-thumbtack fa-xs self-center" />
      {{ pinnedConversationStore.getCount }}
      {{ $t('pinconversation.pinned') }}
    </button>
  </div>
</template>

<script>
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';

export default {
  setup() {
    
    function getIndexByParams(param) {
      return window.location.pathname.split('/')[param];
    }

    function getConversationType(type) {
      switch (type) {
        case 'channels':
          return 'BenchChannel';
        case 'profiles':
          return 'Profile';
        case 'groups':
          return 'Group';
        default:
          return;
      }
    }
    const pinnedConversationStore = usePinnedConversation();
    const conversation_type = getIndexByParams(1);
    const conversation_id = getIndexByParams(2);
    pinnedConversationStore.index(
      getConversationType(conversation_type),
      conversation_id
    );
    return { pinnedConversationStore };
  },
};
</script>
