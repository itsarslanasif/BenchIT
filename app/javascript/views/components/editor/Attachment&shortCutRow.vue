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
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
import { ref } from 'vue';
export default {
  props: ['object'],
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
    onSelect(object) {
      if (object.label === this.$t('create_text_snippet.create_text_snippet')) {
        this.ShortcutAndAttachmentStore.toggleShowCreateTextSnippitModal();
        this.ShortcutAndAttachmentStore.showModalInThread = false;
        this.ShortcutAndAttachmentStore.showModalInChat = false;
      }
    },
  },
};
</script>
