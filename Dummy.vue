<!-- <template>
  <div
    v-if="editor"
    class="flex justify-center flex-col p-2 rounded-lg border border-black-400 m-1 focus:border-primaryHover"
  >
    <div class="flex items-center gap-1">
      <button
        @click="editor.chain().focus().toggleBold().run()"
        :disabled="!editor.can().chain().focus().toggleBold().run()"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
        :class="{ 'bg-transparent': editor.isActive('bold') }"
      >
        <font-awesome-icon icon="fa-bold" />
      </button>
      <button
        @click="editor.chain().focus().toggleItalic().run()"
        :disabled="!editor.can().chain().focus().toggleItalic().run()"
        :class="{ 'bg-transparent': editor.isActive('italic') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-italic" />
      </button>
      <button
        @click="editor.chain().focus().toggleStrike().run()"
        :disabled="!editor.can().chain().focus().toggleStrike().run()"
        :class="{ 'bg-transparent': editor.isActive('strike') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-strikethrough" />
      </button>
      <div class="vl" />
      <button
        @click="setLink"
        :class="{ 'bg-transparent': editor.isActive('link') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-link" />
      </button>
      <div class="vl" />

      <button
        @click="editor.chain().focus().toggleOrderedList().run()"
        :class="{ 'bg-transparent': editor.isActive('orderedList') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-list-ol" />
      </button>
      <button
        @click="editor.chain().focus().toggleBulletList().run()"
        :class="{ 'bg-transparent': editor.isActive('bulletList') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-list" />
      </button>
      <div class="vl" />
      <button
        @click="editor.chain().focus().toggleBlockquote().run()"
        :class="{ 'bg-transparent': editor.isActive('blockquote') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-quote-right" />
      </button>
      <div class="vl" />
      <button
        @click="editor.chain().focus().toggleCode().run()"
        :disabled="!editor.can().chain().focus().toggleCode().run()"
        :class="{ 'bg-transparent': editor.isActive('code') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-code" />
      </button>
      <button
        @click="editor.chain().focus().toggleCodeBlock().run()"
        :class="{ 'bg-transparent': editor.isActive('codeBlock') }"
        class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
      >
        <font-awesome-icon icon="fa-laptop-code" />
      </button>
    </div>

    <EditorContent :editor="editor" class="mt-4" />

    <div class="flex justify-between mt-4">
      <div class="flex items-center gap-1">
        <button
          @click="editor.chain().focus().toggleBold().run()"
          :disabled="!editor.can().chain().focus().toggleBold().run()"
          class="px-2 py-1 bg-transparent rounded-full focus:outline-none focus:bg-black-300"
          :class="{ 'bg-transparent': editor.isActive('bold') }"
        >
          <font-awesome-icon icon="fa-plus" />
        </button>
        <div class="vl" />
        <button
          @click="editor.chain().focus().toggleItalic().run()"
          :disabled="!editor.can().chain().focus().toggleItalic().run()"
          :class="{ 'bg-transparent': editor.isActive('italic') }"
          class="px-2 py-1 hover:bg-transparent rounded italic focus:outline-none focus:bg-black-300"
        >
          <font-awesome-icon icon="fa-video" />
        </button>
        <button
          @click="editor.chain().focus().toggleStrike().run()"
          :disabled="!editor.can().chain().focus().toggleStrike().run()"
          :class="{ 'bg-transparent': editor.isActive('strike') }"
          class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
        >
          <font-awesome-icon icon="fa-microphone" />
        </button>
        <div class="vl" />
        <button
          @click="editor.chain().focus().toggleCode().run()"
          :disabled="!editor.can().chain().focus().toggleCode().run()"
          :class="{ 'bg-transparent': editor.isActive('code') }"
          class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
        >
          <font-awesome-icon icon="fa-smile" />
        </button>
        <button
          @click="editor.chain().focus().toggleOrderedList().run()"
          :class="{ 'bg-transparent': editor.isActive('orderedList') }"
          class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
        >
          <font-awesome-icon icon="fa-at" />
        </button>
        <button
          @click="editor.chain().focus().toggleBulletList().run()"
          :class="{ 'bg-transparent': editor.isActive('bulletList') }"
          class="px-2 py-1 hover:bg-transparent rounded focus:outline-none focus:bg-black-300"
        >
          <font-awesome-icon icon="fa-toggle-off" />
        </button>
      </div>
      <div class="bg-success flex rounded items-center">
        <button
          class="px-2 py-1 bg-red-500 hover:bg-successHover rounded text-white focus:outline-none"
          @click="sendMessagePayload"
        >
          <font-awesome-icon icon="fa-paper-plane" />
        </button>
        <div class="vl" />
        <button
          class="px-2 py-1 hover:bg-successHover rounded text-white focus:outline-none"
        >
          <font-awesome-icon icon="fa-chevron-down" />
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import StarterKit from '@tiptap/starter-kit';
import Placeholder from '@tiptap/extension-placeholder';
import { Editor, EditorContent } from '@tiptap/vue-3';
import { NDivider } from 'naive-ui';
import { markdownToBlocks } from '@tryfabric/mack';
import TurndownService from 'turndown';

export default {
  components: {
    EditorContent,
    NDivider,
  },

  data() {
    return {
      editor: null,
      editorContent: '',
      content: ''
    };
  },

  mounted() {
    this.editor = new Editor({
      extensions: [
        StarterKit,
        Placeholder.configure({
          placeholder: 'Write something …',
          // Use different placeholders depending on the node type:
          // placeholder: ({ node }) => {
          //   if (node.type.name === 'heading') {
          //     return 'What’s the title?'
          //   }

          //   return 'Can you add some further context?'
          // },
        }),
      ],
      content: this.content,
      onUpdate: () => {
        this.editorContent = this.editor.getHTML();
      },
    });
  },

  beforeUnmount() {
    this.editor.destroy();
  },

  setup() {
    const turndownService = new TurndownService();
    return {
      turndownService,
    };
  },
  props: ['sendMessage'],
  methods: {
    setLink() {
      const previousUrl = this.editor.getAttributes('link').href;
      const url = window.prompt('URL', previousUrl);

      // cancelled
      if (url === null) {
        return;
      }

      // empty
      if (url === '') {
        this.editor.chain().focus().extendMarkRange('link').unsetLink().run();

        return;
      }

      // update link
      this.editor
        .chain()
        .focus()
        .extendMarkRange('link')
        .setLink({ href: url })
        .run();
    },

    async makeBlocks(line) {
      const block = await markdownToBlocks(line);
      return block[0];
    },
    async sendMessagePayload() {
      const mrkdwn = [];
      const htmlList = this.editorContent.split('<br>');
      htmlList.forEach(async line => {
        line = line.replace(/<s>/g, '~~')
        line = line.replace(/<\/s>/g, '~~')
        console.log(line);
        mrkdwn.push(this.turndownService.turndown(line));
      });
      const result = await Promise.all(
        mrkdwn.map(async line => {
          line = line.replace(/\*\*/g, '****')
          console.log(line);
          return await this.makeBlocks(line);
        })
      );
      console.log(result, htmlList);
      this.sendMessage({ blocks: result }, [], null);
    },
  },
};
</script>

<style lang="scss">
.ProseMirror p.is-editor-empty:first-child::before {
  content: attr(data-placeholder);
  float: left;
  color: #adb5bd;
  pointer-events: none;
  height: 0;
}

.ProseMirror p.is-editor-empty:first-child::before {
  content: attr(data-placeholder);
  float: left;
  color: #adb5bd;
  pointer-events: none;
  height: 0;
}
.ProseMirror {
  outline: none;
  > * + * {
    // margin-top: 0.75em;
  }
  ul {
    padding: 0 1rem;
    li {
      list-style: disc;
      li {
        list-style: circle;
        li {
          list-style: square;
        }
      }
    }
  }
  ol {
    padding: 0 1rem;
    li {
      list-style-type: style;
      li {
        list-style: lower-alpha;
      }
    }
  }

  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    line-height: 1.1;
  }

  code {
    background-color: #cec39e31;
    color: #e6a026;
    border-radius: 0.3rem;
    border-width: 0.02rem;
    border-color: #adb5bd;
    padding: 0.2rem;
  }

  pre {
    background: #5a4d041c;
    font-family: 'JetBrainsMono', monospace;
    color: #726933;
    padding: 0.75rem 1rem;
    border-radius: 0.3rem;
    border-width: 0.01rem;

    code {
      color: inherit;
      padding: 0;
      background: none;
      font-size: 0.8rem;
      border-width: 0;
    }
  }

  img {
    max-width: 100%;
    height: auto;
  }

  blockquote {
    padding-left: 1rem;
    border-left: 4px solid #b9996448;
  }

  hr {
    border: none;
    border-top: 2px solid rgba(#0d0d0d, 0.1);
    margin: 2rem 0;
  }
}
button {
  color: #474849;
}
.vl {
  border-left: 1px solid rgba(224, 226, 224, 0.752);
  height: 25px;
}
</style> -->
