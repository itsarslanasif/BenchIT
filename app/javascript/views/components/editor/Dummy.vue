<template>
  <div class="">
    <div class="flex gap-5">
      <button @click="editor.chain().focus().toggleBold().run()">B</button>
      <button @click="editor.chain().focus().toggleItalic().run()">I</button>
      <button @click="editor.chain().focus().toggleUnderline().run()">U</button>
      <button @click="editor.chain().focus().toggleStrike().run()">S</button>
      <button @click="editor.chain().focus().toggleCode().run()">C</button>
    </div>
    <editor-content :editor="editor" />
  </div>
</template>

<script>
import { Editor, EditorContent } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';

export default {
  components: {
    EditorContent,
  },

  data() {
    return {
      editor: null,
      content: '<p>I’m running Tiptap with Vue.js. 🎉</p>',
    };
  },

  methods: {
    updateContent(content) {
      this.content = content;
      console.log(this.content);
    },
  },

  mounted() {
    this.editor = new Editor({
      extensions: [StarterKit],
    });
  },

  beforeUnmount() {
    this.editor.destroy();
  },
};
</script>

<style>
.ProseMirror {
  padding: 10px;
  border-radius: 5px;
  border: none;
}
</style>
