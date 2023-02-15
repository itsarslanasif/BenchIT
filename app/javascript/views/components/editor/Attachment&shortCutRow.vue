<template>
  <div
    class="flex px-1 py-2 w-full hover-trigger hover:bg-slate-800 rounded-md group hover:text-white"
    @click="onSelect(shortcut)"
  >
    <span> <font-awesome-icon class="h-5 w-5" :icon="shortcut.icon" /></span>
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
        // this.ShortcutAndAttachmentStore.showCreateTextSnippitModal =
        //   !this.isThread;
        // this.ShortcutAndAttachmentStore.showCreateTextSnippitModalThread =
        //   this.isThread;

        // this.ShortcutAndAttachmentStore.showModalInThread = false;
        // this.ShortcutAndAttachmentStore.showModalInChat = false;
        this.toggleCreateTextSnippetModal();
      }
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
