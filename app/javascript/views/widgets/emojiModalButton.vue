<template>
  <n-popover style="backgroundcolor: #1e293b" trigger="hover">
    <template #trigger>
      <template v-if="actionText == $t('emojiModalButton.more_actions')">
        <n-dropdown
          class="rounded-md border border-slate-100"
          placement="bottom-start"
          size="small"
          trigger="click"
          :message="message"
          :options="Options.getOptions()"
          @mouseleave="action"
          @select="
            handleSelect($event, message, pinnedConversationStore, messageStore)
          "
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
import Options from './options.js';
import { NPopover, NDropdown } from 'naive-ui';
import { usePinnedConversation } from '../../stores/UsePinnedConversationStore';
import { pinMessage } from '../../api/messages/pinnedMessages';

import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useMessageStore } from '../../stores/useMessagesStore';
import { errorHandler } from './messageProvider';

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
    'setDeleteModal',
    'setUnpinModal',
  ],
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    const currentProfileStore = useCurrentProfileStore();
    const messageStore = useMessageStore();
    return { pinnedConversationStore, currentProfileStore, messageStore };
  },
  beforeMount() {
    if (this.message) {
      this.Options = new Options(
        this.message.pinned,
        this.message.is_info,
        this.isMyMessage(this.currentProfileStore.currentProfile, this.message)
      );
    }
  },
  data() {
    return {
      Options: '',
    };
  },
  methods: {
    isMyMessage(currentProfileStore, message) {
      return message.sender_id == currentProfileStore.id;
    },
    async handleSelect(key, message, messageStore) {
      switch (key) {
        case 'copy-link':
          this.copyLinkToMessage(message);
          break;
        case 'delete-message':
          this.setDeleteModal();
          break;
        case 'pin-to-this-conversation':
          try {
            await pinMessage(message.bench_conversation_id, message.id);
          } catch (e) {
            errorHandler(e.response.data.message);
          }
          break;
        case 'unpin-from-this-conversation':
          this.setUnpinModal();
          break;
        case 'edit-message':
          if (message) messageStore.setMessageToEdit(message);
          break;
      }
    },
    copyLinkToMessage(message) {
      let tempText = null;
      if (message.conversationable_type == 'BenchChannel') {
        tempText = `${import.meta.env.VITE_APP_SERVER_URL}/channels/${
          message.conversationable_id
        }/${message.id}`;
      } else if (message.conversationable_type == 'Profile') {
        tempText = `${import.meta.env.VITE_APP_SERVER_URL}/profiles/${
          this.$route.params.id
        }/${message.id}`;
      } else if (message.conversationable_type == 'Group') {
        tempText = `${import.meta.env.VITE_APP_SERVER_URL}/groups/${
          this.$route.params.id
        }/${message.id}`;
      }
      navigator.clipboard.writeText(tempText);
    },
  },
};
</script>
