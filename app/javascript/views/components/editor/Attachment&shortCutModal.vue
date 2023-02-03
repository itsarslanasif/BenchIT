<template>
  <div
    v-click-outside="closeModal"
    v-show="isThread ? fileStore.showModalInThread : fileStore.showModalInChat"
  >
    <n-card
      :bordered="false"
      size="huge"
      class="border border-black-300"
      :class="{ 'bg-danger': isThread }"
      style="width: 400px"
    >
      <template #header>
        <n-space vertical>
          <n-input
            type="text"
            size="large"
            focus="true"
            v-model:value="searchInputField"
            @keyup="handleSubmit(searchInputField, sortValue)"
            placeholder="Search shortchuts"
          >
            <template #prefix>
              <n-icon :component="SearchOutline" />
            </template>
          </n-input>
        </n-space>
      </template>

      <template #footer>
        <span class="text-black-500">Sortcuts</span>
        <div v-for="option in shortcutOptions" :key="option.key">
          <AttachmentShortCutRow :object="option" />
        </div>
        <hr class="my-2 text-black-500" />
        <span class="text-black-500">Attachments</span>
        <div v-for="option in AttachmentOptions" :key="option.key">
          <AttachmentShortCutRow :object="option" />
        </div>
      </template>
    </n-card>
  </div>
</template>

<script>
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { NModal, NInput, NCard, NIcon, NSpace, NDivider } from 'naive-ui';
import AttachmentShortCutRow from './Attachment&shortCutRow.vue';
import { SearchOutline } from '@vicons/ionicons5';
import vClickOutside from 'click-outside-vue3';
export default {
  props: ['show', 'isThread'],
  components: {
    NModal,
    NCard,
    NInput,
    NIcon,
    NSpace,
    AttachmentShortCutRow,
    NDivider,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  methods: {
    closeModal() {
      this.fileStore.showModalInThread = false;
      this.fileStore.showModalInChat = false;
    },
  },
  setup() {
    const fileStore = useRecentFilesStore();
    const shortcutOptions = [
      {
        label: 'Create a post',
        key: 'Create a post',
        icon: 'fa-solid fa-pen-to-square',
      },
      {
        label: 'Add from Google Drive',
        key: 'Add from Google Drive',
        icon: 'fa-solid  fa-hard-drive',
      },
      {
        label: 'Create a text snippet',
        key: 'Create a text snippet',
        icon: 'fa-solid   fa-file-lines',
      },
      {
        label: 'Browse all shortcyts',
        key: 'Browse all shortcyts',
        icon: 'fa-solid fa-ellipsis',
      },
    ];
    const AttachmentOptions = [
      {
        label: 'Recent files',
        key: 'Recent files',
        icon: 'fa-solid fa-layer-group',
      },
      {
        label: 'Upload from your computer',
        key: 'Upload from your computer',
        icon: 'fa-solid fa-laptop',
      },
    ];
    return {
      fileStore,
      shortcutOptions,
      AttachmentOptions,
      SearchOutline,
    };
  },
};
</script>
