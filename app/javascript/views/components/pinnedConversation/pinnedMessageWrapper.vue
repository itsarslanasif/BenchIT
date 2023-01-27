<template>
  <n-tooltip trigger="hover" placement="bottom-end">
    <template #trigger>
      <div
        class="text-black-800 justify-center flex items-center float-right cursor-pointer mr-4 mt-3 text-base z-10 relative"
        @click="setUnpinModal"
      >
        <font-awesome-icon icon="fa-solid fa-xmark" />
      </div>
    </template>
    {{ $t('pinconversation.title') }}
  </n-tooltip>
  <div class="bg-white border border-black-400 rounded-lg drop-shadow-md p-1">
    <div>
      <PinnedMessageContent :currMessage="currMessage" />
    </div>
  </div>
  <UnPinModal
    v-model:show="showUnpinModal"
    :currMessage="currMessage"
    :setUnpinModal="setUnpinModal"
  />
</template>

<script>
import UnPinModal from './unpinModal.vue';
import PinnedMessageContent from './pinnedMessage.vue';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import { NTooltip } from 'naive-ui';
export default {
  name: 'PinMessageWrapper',
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
  },
  data() {
    return {
      showUnpinModal: false,
    };
  },
  components: {
    UnPinModal,
    PinnedMessageContent,
    NTooltip,
  },
  props: {
    currMessage: {
      type: Object,
      default: undefined,
    },
  },
  methods: {
    setUnpinModal() {
      this.pinnedConversationStore.showAlert = true;
      this.showUnpinModal = !this.showUnpinModal;
    },
  },
};
</script>
