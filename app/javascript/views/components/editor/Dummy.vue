<template>
  <div class="bg-warning">
    <editor-content :editor="editor" />
  </div>
</template>

<script>
import { Editor, EditorContent } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';
import Bold from '@tiptap/extension-bold';

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
    toggleBold() {
      this.editor.chain().focus().toggleBold().run()
      console.log(this.editor);
    },
    updateContent (content) {
      this.content = content
      console.log(this.content);
    }
  },

  mounted() {
    this.editor = new Editor({
      header: [Bold],
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
  height: 30%;
  border: none;
}
</style>
