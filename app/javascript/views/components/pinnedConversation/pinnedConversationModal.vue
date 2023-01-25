<template>
  <div
    v-click-outside="pinnedConversationStore.closeModal"
    v-if="pinnedConversationStore.pinToggle && pinnedConversationStore.getCount"
    class="flex overflow-auto z-10 -mt-1 px-2 py-2 ml-1 absolute flex-col drop-shadow-2xl border-black-300 bg-gray-50 w-2/6 max-h-500 border min-w-95 rounded-lg"
    :class="{ hidden: pinnedConversationStore.showAlert }"
  >
    <div
      v-for="message in pinnedConversationStore.getPinnedConversation"
      :key="message.pin.id"
    >
      <div class="mt-2">
        <PinnedMessageWrapperVue
          :curr-message="message"
          :prev-message="prevMessage"
        />
      </div>
    </div>
  </div>
</template>
<script>
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import MessageWrapper from '../messages/MessageWrapper.vue';
import PinnedMessageWrapperVue from './pinnedMessageWrapper.vue';
import vClickOutside from 'click-outside-vue3';

export default {
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },

  components: {
    MessageWrapper,
    PinnedMessageWrapperVue,
  },
};
</script>
