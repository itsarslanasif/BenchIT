<template>
  <ChatHeader :chat="chat" />
  <ChatBody />
  <div class="editor">
    <editor
      api-key="v69g5pnxcpt0m2kmjntucft1sek0y2g7qw17n2scwu0pi76w"
      :init="{
        menubar: false,
        statusbar: false,
        plugins: 'lists link code',
        toolbar:
          'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code',
      }"
    />
  </div>
</template>

<script>
import ChatHeader from './ChatHeader.vue';
import chats from './data/chats';
import ChatBody from './ChatBody.vue';
import { NInput, NSpace } from 'naive-ui';
import Editor from '@tinymce/tinymce-vue';
export default {
  name: 'Chat',
  components: {
    ChatHeader,
    ChatBody,
    NInput,
    NSpace,
    editor: Editor,
  },
  data() {
    return {
      chat: chats[1],
    };
  },
};
</script>
<style>
.editor {
  bottom: 0;
  float: left;
  width: 100%;
}
</style>
