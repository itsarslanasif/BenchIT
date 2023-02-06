<template>
  <div
    class="flex px-1 py-2 w-full hover-trigger hover:bg-slate-800 rounded-md group hover:text-white"
    @click="onSelect(object)"
  >
    <span> <font-awesome-icon class="h-5 w-5" :icon="object.icon" /></span>
    <span class="px-2 cursor-pointer">{{ object.label }}</span>
  </div>
</template>

<script>
import { useShortcutAttachmentStore } from '../../../stores/useShortcut&AttachmentStore';
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { ref } from 'vue';
export default {
  props: ['object'],
  setup() {
    const ShortcutAndAttachmentStore = useShortcutAttachmentStore();
    const fileStore = useRecentFilesStore();
    return {
      ShortcutAndAttachmentStore,
      fileStore,
    };
  },
  data() {
    return {
      showModal: ref(false),
    };
  },
  methods: {
    onSelect(object) {
      if (object.label === 'Create a text snippet') {
        this.ShortcutAndAttachmentStore.toggleShowCreateTextSnippitModal();
        this.fileStore.showModalInThread = false;
        this.fileStore.showModalInChat = false;
      }
    },
  },
};
</script>
