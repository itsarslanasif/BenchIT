<template>
  <n-popover style="backgroundcolor: #1e293b" trigger="hover">
    <template #trigger>
      <template v-if="actionText == $t('emojiModalButton.more_actions')">
        <n-dropdown
          class="rounded-md border border-slate-100"
          placement="bottom-start"
          size="medium"
          trigger="click"
          :message="message"
          :options="options"
          @mouseleave="action"
          @select="handleSelect($event, message, pinnedConversationStore)"
        >
          <span
            @click="action"
            class="p-2 text-sm hover:bg-transparent px-3 rounded"
          >
            <font-awesome-icon :icon="icon" />
          </span>
        </n-dropdown>
      </template>
      <template v-else>
        <span
          @click="action(emoji)"
          class="p-2 text-sm hover:bg-transparent cursor-pointer rounded"
        >
          <font-awesome-icon v-if="icon" :icon="icon" />
          <template v-if="emoji">
            {{ emoji.i }}
          </template>
        </span>
      </template>
    </template>
    <span>{{ actionText }}</span>
  </n-popover>
</template>

<script>
import options from './options.js';
import { NPopover, NDropdown } from 'naive-ui';
import { usePinnedConversation } from '../../stores/UsePinnedConversationStore';
import { deleteMessage } from '../../api/messages';
export default {
  name: 'EmojiModalButton',
  components: { NPopover, NDropdown },
  props: [
    'icon',
    'emoji',
    'actionText',
    'action',
    'message',
    'pinnedConversationStore',
  ],
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
  },
  data() {
    return {
      options,
      handleSelect(key, message, pinnedConversationStore) {
        switch (key) {
          case 'copy-link':
            let tempText = document.createElement('input');
            tempText.value = `${import.meta.env.VITE_APP_SERVER_URL}channels/${
              message.bench_conversation_id
            }/${message.id}`;
            document.body.appendChild(tempText);
            tempText.select();
            document.execCommand('copy');
            document.body.removeChild(tempText);
            break;
          case 'delete-message':
            deleteMessage(message.id);
            break;
          case 'pin-to-this-conversation':
            if (!pinnedConversationStore.isPinned(message)) {
              pinnedConversationStore.pinMessage(message);
            } else {
              pinnedConversationStore.unPinMessage(message);
              if (
                pinnedConversationStore.getCount == 0 &&
                pinnedConversationStore.getPinToggle
              ) {
                pinnedConversationStore.togglePin();
              }
            }
            break;
        }
      },
    };
  },
};
</script>
