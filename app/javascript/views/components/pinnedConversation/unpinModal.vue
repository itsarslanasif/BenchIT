<template>
  <n-modal
    v-model:show="pinnedConversationStore.showAlert"
    class="custom-card rounded-lg w-180"
    preset="card"
    :bordered="false"
    size="huge"
    content-style="overflow-y: auto; overflow-x: hiddden; max-height: 440px"
    @click.prevent.stop
    aria-modal="true"
  >
    <template #header>
      <span class="text-2xl font-bold">{{
        $t('pinconversation.title')
      }}</span>
    </template>
    <span>{{ $t('pinconversation.confirmation') }}</span>
    <div
      class="bg-white border border-black-400 rounded-md drop-shadow-md p-1 mt-4"
    >
      <PinnedMessageContent :currMessage="currMessage" />
    </div>
    <div class="flex float-right mt-6">
      <button
        class="font-semibold text-black border px-4 h-9 rounded-md border-black-400 mr-2 hover:bg-black-100"
        @click="handleClick()"
      >
        {{ $t('actions.cancel') }}
      </button>
      <button
        class="font-semibold bg-green-900 text-white border px-4 h-9 rounded-md"
        @click="unpinMessage"
      >
        {{ $t('pinconversation.title') }}
      </button>
    </div>
  </n-modal>
</template>

<script>
import { NModal, NAvatar, NPopover } from 'naive-ui';
import PinnedMessageContent from './pinnedMessage.vue';
import { unPinMessage } from '../../../api/messages/pinnedMessages';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';

export default {
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
  },
  props: ['currMessage', 'setUnpinModal'],
  components: {
    NModal,
    NAvatar,
    NPopover,
    PinnedMessageContent,
  },
  data() {
    return {};
  },
  computed: {},
  methods: {
    unpinMessage() {
      try {
        unPinMessage(this.currMessage.pin.id);
      } catch (e) {
        console.error(e);
      }
      if (
        this.pinnedConversationStore.getCount == 0 &&
        this.pinnedConversationStore.getPinToggle
      ) {
        this.pinnedConversationStore.togglePin();
      }
      this.setUnpinModal();
      this.pinnedConversationStore.closeModal();
      this.pinnedConversationStore.showAlert = false;
    },
    handleClick() {
      this.setUnpinModal();
      this.pinnedConversationStore.closeModal();
      this.pinnedConversationStore.showAlert = false;
    },
  },
};
</script>
