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
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';
import { onMounted } from 'vue';

export default {
  setup() {
    const messagesStore = useMessageStore();
    const pinnedConversationStore = usePinnedConversation();
    const { selectedChat } = storeToRefs(messagesStore)

    onMounted(()=>{
      pinnedConversationStore.index(
      selectedChat.value.bench_conversation_id
    );
    })

    return { pinnedConversationStore };
  },
};
</script>
