<template lang="">
  <div class="w-11/12">
    <div v-if="openAttach">
      <font-awesome-icon
        icon="fa-circle-xmark"
        @click="closeModal"
        class="text-xl p-2 m-3 hover:bg-slate-100 rounded-md"
      />
    </div>
    <div v-else>
      <font-awesome-icon
        icon="fa-plus-circle"
        @click="openAttach = true"
        class="text-xl p-2 m-3 hover:bg-slate-100 rounded-md"
      />
    </div>
    <div
      v-if="openAttach && !recentFiles"
      class="bottom-0 ml-12 py-2 absolute w-auto bg-primary text-white rounded-md h-auto"
    >
      <div class="px-4 py-1 w-11/12">{{ $t('send_attachments.title') }}</div>
      <div
        class="px-4 py-1 hover:bg-primaryHover cursor-pointer"
        @click="recentFiles = !recentFiles"
      >
        <font-awesome-icon icon="fa-layer-group" class="mr-2 text-xs" />
        {{ $t('send_attachments.recent_files') }}
      </div>
      <label for="getFile">
        <div class="px-4 py-1 hover:bg-primaryHover cursor-pointer">
          <font-awesome-icon icon="fa-laptop" class="mr-2 text-xs" />
          {{ $t('send_attachments.from_computer') }}
        </div>
      </label>
      <input type="file" id="getFile" @change="uploadFile" ref="file" class="hidden" />
      <img :src="imgSrc" v-if="imgSrc" />
    </div>
    <div
      v-if="openAttach && recentFiles"
      class="bottom-0 ml-12 absolute min-w-1/4 max-w-auto bg-primary text-white rounded-md h-auto"
    >
      <div class="flex p-2 border-b border-slate-100">
        <div
          class="mr-3 hover:bg-primaryHover px-3 py-2 rounded-md"
          @click="recentFiles = false"
        >
          <font-awesome-icon icon="fa-arrow-left" />
        </div>
        <div class="text-center py-2">
          {{ $t('send_attachments.recent_files') }}
        </div>
      </div>
      <div>
        <div
          v-for="file in recentFilesData"
          :key="file"
          @click="selectFromRecent(file)"
        >
          <div class="flex p-2 hover:bg-primaryHover">
            <div class="mr-2">
              <img :src="file.attachment_link" class="w-10 h-10" />
            </div>
            <div>
              {{ file.attachment.filename }}<br />
              {{ getFileType(file.attachment.content_type) }}
              {{ $t('send_attachments.divider') }}
              {{ getDate(file.attachment.created_at) }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { useRecentFilesStore } from '../../../stores/useRecentFilesStore';
import { getFileFromURL } from '../../../api/attachments/attachments';
export default {
  props: ['getImages'],
  data() {
    return {
      openAttach: false,
      file: null,
      imgSrc: '',
      recentFiles: false,
    };
  },
  setup() {
    const recentFilesStore = useRecentFilesStore();
    recentFilesStore.index();
    return {
      recentFilesData: recentFilesStore.getRecentFiles,
    };
  },
  methods: {
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
