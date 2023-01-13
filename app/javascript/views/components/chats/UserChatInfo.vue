<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div
        class="flex px-1 mx-3 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer"
      >
        <n-avatar
          class="mr-1 self-center"
          size="small"
          :src="selectedChat.image_url"
        />
        <span
          v-if="selectedChat.isActive"
          class="bg-success rounded-full border-primary border-2 h-3 w-3 relative -ml-3 mt-5"
        />
        <span
          v-else
          class="bg-black-700 rounded-full border-white border-2 h-3 w-3 relative -ml-3 mt-5"
        />
        <span v-if="selectedChat">
          <p class="text-xl self-center font-semibold pl-1">
            {{ selectedChat.username }}
          </p>
        </span>
        <span v-if="selectedChat.status" class="self-center mx-1"
          >{{ selectedChat.status.emoji }}
        </span>
        <i class="fa-solid fa-chevron-down self-center mx-1" />
      </div>
      <div
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
        <i class="fa-solid fa-phone self-center" />
      </div>
    </div>
  </div>
</template>

<script>
import { NAvatar, NIcon } from 'naive-ui';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore.js';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore.js';
import { storeToRefs } from 'pinia';
export default {
  name: 'UserChatInfo',
  components: { NAvatar, NIcon },
  setup() {
    const directMessagesStore = useDirectMessagesStore();
    const leftPaneStore = useLeftpaneStore()
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { directMessagesStore, selectedChat, leftPaneStore };
  },
};
</script>

<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
