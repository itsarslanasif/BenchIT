<template>
  <div>
    <div class="flex p-1 px-3 border-x-0 border-t-0 border-b border-black-300">
      <div class="flex overflow-y-hidden text-ellipsis p-1">
        <p class="text-slate-800 text-xl font-semibold">
          {{ $t('actions.saved_items') }}
        </p>
      </div>
    </div>
    <div class="overflow-auto chatBody bg-gray-100">
      <PinnedConversationModel />
      <div v-for="message in messages" :key="message.id" :id="message.id">
        <div class="border border-black-300 m-5">
          <SaveMessageWrapper :currMessage="message" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getSaveMessages } from '../../../api/save_messages/savemessages.js';
import SaveMessageWrapper from './SaveMessageWrapper.vue';
import PinnedConversationModel from '../pinnedConversation/pinnedConversationModel.vue';
import { useSavedItemsStore } from '../../../stores/useSavedItemStore.js';

export default {
  name: 'SaveMessageBody',
  components: {
    SaveMessageWrapper,
    PinnedConversationModel,
  },
  setup() {
    const savedItemsStore = useSavedItemsStore();
    return { savedItemsStore };
  },
  data() {
    return {
      messages: [],
      message: null,
    };
  },
  async mounted() {
    this.messages = await getSaveMessages();
    this.savedItemsStore.savedItems = this.messages;
    console.log(this.messages);
  },
};
</script>
<style scoped>
.chatBody {
  height: 87vh;
}

.highlight {
  animation: background-fade 7s;
}

@keyframes background-fade {
  0% {
    background: rgba(253, 245, 221, 255);
  }
}
</style>
