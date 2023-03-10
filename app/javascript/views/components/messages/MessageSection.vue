<template>
  <div class="text-sm">
    <div class="rich-content max-w-5xl" v-html="text"></div>
  </div>
</template>

<script>
import { Remarkable } from 'remarkable';
import { useProfileStore } from '../../../stores/useProfileStore';
export default {
  props: {
    section: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      text: '',
    };
  },
  async mounted() {
    const html = new Remarkable({ html: true });
    const { replacedStr } = await this.profileStore.getMentionsFromIds(
      html.render(this.section.text.text)
    );
    this.text = replacedStr;
  },
  setup() {
    const profileStore = useProfileStore();
    return {
      profileStore,
    };
  },
};
</script>
<style lang="scss">
.rich-content {
  ul {
    li {
      margin-left: 10px;
      list-style-type: disc;

      li {
        list-style-type: circle;

        li {
          list-style-type: square;
        }
      }
    }
  }

  ol {
    li {
      margin-left: 10px;
      list-style-type: decimal;

      li {
        list-style-type: lower-alpha;
      }
    }
  }
  code {
    font-size: 12px;
    background-color: #cec39e31;
    color: #e6a026;
    border-radius: 0.3rem;
    border-width: 0.02rem;
    border-color: #adb5bd;
    padding: 0.2rem;
  }

  pre {
    background: #cdc4ab1c;
    font-family: 'JetBrainsMono', monospace;
    color: #9f8807eb;
    padding: 0.5rem;
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
  a {
    color: rgba(39, 39, 238, 0.914);
    text-decoration: underline;
  }
}
</style>
