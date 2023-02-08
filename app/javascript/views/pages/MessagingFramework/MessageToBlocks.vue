<template>
  <div>
    See console
    <br />
    <br />
    {{ format(testString) }}
  </div>
</template>

<script>
import { markdownToBlocks } from '@tryfabric/mack';
import TextEditor from '@tinymce/tinymce-vue';
export default {
  components: { editor: TextEditor },
  data() {
    return {
      testString: `<p>this is a paragraph<br /> and <br /><strong>this is bold&nbsp;</strong><br />and
      <em>I am italic</em>
    </p>`,
      testString2: `<p>This is a paragraph<br />this is another paragraph</p>`,
      newMessage: '',
      blocks: [],
      message: `
# Hello world

* bulleted item 1
* bulleted item 2

abc _123_

![cat](https://images.unsplash.com/photo-1574158622682-e40e69881006)
`,
    };
  },
  methods: {
    async makeBlocks(line) {
      let block = await markdownToBlocks(line);
      this.blocks.push(block[0]);
    },
    getBlock() {
      return this.blocks;
    },
    format(markdown) {
      markdown = markdown.replace(/<p>/g, '# ').replace(/<\/p>/g, '');
      markdown = markdown.replace(/<strong>(.*?)<\/strong>/g, '**$1**');
      markdown = markdown.replace(/<em>(.*?)<\/em>/g, '_$1_');
      let lines = markdown.split('<br />');

      lines.forEach(line => {
        this.makeBlocks(line);
      });
      let temp = this.blocks;
      console.log(temp);
    },
  },
};
</script>
