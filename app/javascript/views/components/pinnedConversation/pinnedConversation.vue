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
export default {
  props: ['selectedChat', 'pinnedConversationStore'],
  setup(props) {
    function getConversationType() {
      if (props.selectedChat.is_private !== undefined) {
        return 'BenchChannel';
      } else {
        return 'Profile';
      }
    }
    const conversation_id = props.selectedChat.id;
    const conversation_type = getConversationType();
    props.pinnedConversationStore.index(conversation_type, conversation_id);
  },
};
</script>
