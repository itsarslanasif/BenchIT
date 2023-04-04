<template lang="">
  <div>
    <div v-if="openAttach">
      <font-awesome-icon
        icon="fa-circle-xmark"
        @click="closeModal"
        class="p-2 float-left"
      />
    </div>
    <div v-else>
      <font-awesome-icon
        icon="fa-plus"
        @click="openAttach = true"
        class="p-2 float-left"
      />
    </div>
    <div
      class="bottom-0 ml-6 py-2 absolute z-10"
      v-click-outside="closeModal"
      v-if="openAttach"
    >
      <n-card class="border shadow-xl border-black-400 m-0" size="small">
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
          <span class="text-black-500 float-left">{{
            $t('create_text_snippet.shortcuts')
          }}</span>
          <div v-for="option in shortcutOptions" :key="option.key">
            <AttachmentShortCutRow
              :shortcut="option"
              :toggleCreateTextSnippetModal="toggleCreateTextSnippetModal"
              :isThread="isThread"
            />
          </div>
          <hr class="py-2 text-black-500" />
          <span class="text-black-500 float-left">{{
            $t('create_text_snippet.attachments')
          }}</span>
          <label for="getFile">
            <div
              class="flex px-3 py-1 my-1 w-full hover-trigger hover:bg-primaryHover rounded group hover:text-white duration-200"
            >
              <span> <font-awesome-icon icon="fa-laptop" /></span>
              <span class="px-2 cursor-pointer">{{
                $t('send_attachments.from_computer')
              }}</span>
            </div>
          </label>
          <input
            type="file"
            id="getFile"
            @change="uploadFile"
            ref="file"
            class="hidden"
          />
        </template>
      </n-card>
    </div>
    <createTextSnippetModalVue
      v-if="openCreateTextSnippet"
      :sendMessage="sendMessage"
      :recieverName="fileRecieverName"
      :toggleCreateTextSnippetModal="toggleCreateTextSnippetModal"
    />
  </div>
</template>
<script>
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { getFileFromURL } from '../../../api/attachments/attachments';
import vClickOutside from 'click-outside-vue3';
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
import { NModal, NInput, NCard, NIcon, NSpace, NDivider } from 'naive-ui';
import AttachmentShortCutRow from '../editor/Attachment&shortCutRow.vue';
import { SearchOutline } from '@vicons/ionicons5';
import createTextSnippetModalVue from '../editor/CreateTextSnippetModal.vue';
export default {
  props: ['getImages', 'sendMessage', 'fileRecieverName'],
  data() {
    return {
      openAttach: false,
      openCreateTextSnippet: false,
      file: null,
      imgSrc: '',
      recentFiles: false,
      shortcutOptions: [
        {
          label: this.$t('create_text_snippet.create_post'),
          key: this.generateKey(this.$t('create_text_snippet.create_post')),
          icon: 'fa-solid fa-pen-to-square',
        },
        {
          label: this.$t('create_text_snippet.add_to_google_drive'),
          key: this.generateKey(
            this.$t('create_text_snippet.add_to_google_drive')
          ),
          icon: 'fa-solid fa-hard-drive',
        },
        {
          label: this.$t('create_text_snippet.create_text_snippet'),
          key: this.generateKey(
            this.$t('create_text_snippet.create_text_snippet')
          ),
          icon: 'fa-solid fa-file-lines',
        },
        {
          label: this.$t('create_text_snippet.browse_all_shortcuts'),
          key: this.generateKey(
            this.$t('create_text_snippet.browse_all_shortcuts')
          ),
          icon: 'fa-solid fa-ellipsis',
        },
      ],
      AttachmentOptions: [
        {
          label: this.$t('create_text_snippet.recent_files'),
          key: this.generateKey(this.$t('create_text_snippet.recent_files')),
          icon: 'fa-solid fa-layer-group',
        },
        {
          label: this.$t('create_text_snippet.upload_from_your_computer'),
          key: this.generateKey(
            this.$t('create_text_snippet.upload_from_your_computer')
          ),
          icon: 'fa-solid fa-laptop',
        },
      ],
    };
  },
  components: {
    NModal,
    NCard,
    NInput,
    NIcon,
    NSpace,
    AttachmentShortCutRow,
    NDivider,
    createTextSnippetModalVue,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  setup() {
    const recentFilesStore = useRecentFilesStore();
    const shortcutAttachmentStore = useShortcutAndAttachmentStore();
    recentFilesStore.index();
    return {
      recentFilesData: recentFilesStore.getRecentFiles,
      shortcutAttachmentStore,
      SearchOutline,
    };
  },
  beforeUnmount() {
    this.file = null;
    this.imgSrc = null;
  },
  methods: {
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
    uploadFile() {
      this.file = this.$refs.file.files[0];
      this.getImages(this.file);
      this.openAttach = false;
    },
    closeModal() {
      this.openAttach = false;
      this.recentFiles = false;
      this.getDate('2022-12-13T13:55:56.292Z');
    },
    toggleCreateTextSnippetModal() {
      this.openAttach = false;
      this.openCreateTextSnippet = !this.openCreateTextSnippet;
    },
    getDate(currentTimestamp) {
      const date = new Date(currentTimestamp);
      var options = { year: 'numeric', month: 'long', day: 'numeric' };
      return date.toLocaleDateString('en-US', options);
    },
    getFileType(currentFile) {
      const content = currentFile.split('/');
      return content[content.length - 1].toUpperCase();
    },
    async selectFromRecent(attachment) {
      const file = await getFileFromURL(attachment);
      this.getImages(file);
    },
  },
};
</script>
