<template >
  <div
   v-click-outside="pinnedConversationStore.closeModal"
    v-if="pinnedConversationStore.pinToggle && pinnedConversationStore.getCount"
    class="flex overflow-auto z-10 -mt-1 px-2 py-2 ml-1 fixed flex-col drop-shadow-2xl border-black-300  bg-gray-50 w-2/6 maxHeight border rounded-lg"
  >
    <template
      v-for="pin in pinnedConversationStore.getPinnedConversation"
      :key="pin.id"
    >
      <div class="mt-5">
        <PinnedMessageWrapperVue :curr-message="pin.message" :prev-message="prevMessage" />
      </div>
    </template>
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
    MessageWrapper,PinnedMessageWrapperVue
  },
};
</script>

<style scoped>
.maxHeight {
  max-height: 800px;
}
</style>

