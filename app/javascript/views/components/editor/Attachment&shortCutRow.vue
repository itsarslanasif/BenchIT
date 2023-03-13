<template>
  <div
    class="flex px-3 py-1 my-1 w-full hover-trigger hover:bg-primaryHover rounded group hover:text-white duration-200"
    @click="onSelect(shortcut)"
  >
    <span> <font-awesome-icon :icon="shortcut.icon" /></span>
    <span class="px-2 cursor-pointer">{{ shortcut.label }}</span>
  </div>
</template>

<script>
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
import { ref } from 'vue';

export default {
  props: ['shortcut', 'isThread', 'toggleCreateTextSnippetModal'],
  setup() {
    const ShortcutAndAttachmentStore = useShortcutAndAttachmentStore();
    return {
      ShortcutAndAttachmentStore,
    };
  },
  data() {
    return {
      showModal: ref(false),
    };
  },
  methods: {
    onSelect(shortcut) {
      if (
        shortcut.key ===
        this.generateKey(this.$t('create_text_snippet.create_text_snippet'))
      ) {
        this.toggleCreateTextSnippetModal();
      }
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
