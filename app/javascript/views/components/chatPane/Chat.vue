<template>
  <div>
    <ChatHeader :chat="chat" />
    <ChatBody />
  </div>
</template>

<script>
import ChatHeader from './ChatHeader.vue';
import chats from './data/chats';
import ChatBody from './ChatBody.vue';
export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
  },
  data() {
    return {
      chat: chats[1],
    };
  },
};
</script>
