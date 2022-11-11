<template>
  <ChatHeader :chat="chat" />
</template>

<script>
import ChatHeader from './ChatHeader.vue';
import chats from './data/chats';
export default {
  name: 'Chat',
  components: {
    ChatHeader,
  },
  data() {
    return {
      chat: chats[1],
    };
  },
};
</script>
Footer
