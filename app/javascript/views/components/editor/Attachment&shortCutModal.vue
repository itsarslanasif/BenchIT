<template>
  <div
    v-click-outside="closeModal"
    v-show="
      isThread
        ? shortcutAttachmentStore.showModalInThread
        : shortcutAttachmentStore.showModalInChat
    "
  >
    <n-card
      :bordered="false"
      size="huge"
      class="border shadow-xl border-black-300"
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
            :placeholder="$t('create_text_snippet.search_shortcuts')"
          >
            <template #prefix>
              <n-icon :component="SearchOutline" />
            </template>
          </n-input>
        </n-space>
      </template>
      <template #footer>
        <span class="text-black-500">{{
          $t('create_text_snippet.shortcuts')
        }}</span>
        <div v-for="option in shortcutOptions" :key="option.key">
          <AttachmentShortCutRow :shortcut="option" />
        </div>
        <hr class="my-2 text-black-500" />
        <span class="text-black-500">{{
          $t('create_text_snippet.attachments')
        }}</span>
        <div v-for="option in AttachmentOptions" :key="option.key">
          <AttachmentShortCutRow :shortcut="option" />
        </div>
      </template>
    </n-card>
  </div>
</template>

<script>
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
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
      this.shortcutAttachmentStore.showModalInThread = false;
      this.shortcutAttachmentStore.showModalInChat = false;
    },
  },
  data() {
    return {
      shortcutOptions: [
        {
          label: this.$t('create_text_snippet.create_post'),
          key: this.$t('create_text_snippet.create_post'),
          icon: 'fa-solid fa-pen-to-square',
        },
        {
          label: this.$t('create_text_snippet.add_to_google_drive'),
          key: this.$t('create_text_snippet.add_to_google_drive'),
          icon: 'fa-solid fa-hard-drive',
        },
        {
          label: this.$t('create_text_snippet.create_text_snippet'),
          key: this.$t('create_text_snippet.create_text_snippet'),
          icon: 'fa-solid fa-file-lines',
        },
        {
          label: this.$t('create_text_snippet.browse_all_shortcuts'),
          key: this.$t('create_text_snippet.browse_all_shortcuts'),
          icon: 'fa-solid fa-ellipsis',
        },
      ],
      AttachmentOptions: [
        {
          label: this.$t('create_text_snippet.recent_files'),
          key: this.$t('create_text_snippet.recent_files'),
          icon: 'fa-solid fa-layer-group',
        },
        {
          label: this.$t('create_text_snippet.upload_from_your_computer'),
          key: this.$t('create_text_snippet.upload_from_your_computer'),
          icon: 'fa-solid fa-laptop',
        },
      ],
    };
  },
  setup() {
    const shortcutAttachmentStore = useShortcutAndAttachmentStore();
    return {
      shortcutAttachmentStore,
      SearchOutline,
    };
  },
};
</script>
