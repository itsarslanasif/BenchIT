<template>
  <div>
    <div>
      <header>
        <h1 class="ml-10 text-3xl">Saved Items</h1>
      </header>
    </div>
    <div class="overflow-auto chatBody">
      <PinnedConversationModel />
      <div v-for="message in messages" :key="message.id" :id="message.id">
        <SaveMessageWrapper :currMessage="message" />
      </div>
    </div>
  </div>
</template>

<script>
import { getSaveMessages } from '../../../api/save_messages/savemessages.js';
import SaveMessageWrapper from './SaveMessageWrapper.vue';
import PinnedConversationModel from '../pinnedConversation/pinnedConversationModel.vue';

export default {
  name: 'SaveMessageBody',
  components: {
    SaveMessageWrapper,
    PinnedConversationModel,
  },
  data() {
    return {
      messages: [],
      message: null,
    };
  },
  async mounted() {
    this.messages = await getSaveMessages();
  },
};
</script>
<style scoped>
.chatBody {
  height: 57vh;
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
