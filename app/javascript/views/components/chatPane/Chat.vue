<template>
  <div>
    <ChatHeader :chat="chat" />
    <ChatBody />
  </div>
</template>

<script>
import ChatHeader from './ChatHeader.vue';
import ChatBody from './ChatBody.vue';
import chats from './data/chats';
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
