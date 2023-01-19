<template>
  <n-modal
    class="custom-card rounded-lg w-180 h-400"
    preset="card"
    :bordered="false"
    size="huge"
    content-style="overflow-y: auto; overflow-x: hiddden"
  >
    <template #header>
      <span class="text-2xl font-bold"
        >{{ $t('downloadsModal.downloads') }}
      </span>
    </template>
    <template #header-extra v-if="downloadsStore.downloads.length !== 0">
      <div
        class="h-8 w-8 mr-3 hover:bg-black-100 mb-0 text-center rounded-md flex justify-between items-center p-1"
      >
        <n-tooltip trigger="hover">
          <template #trigger>
            <font-awesome-icon
              class="text-xl text-black-600 cursor-pointer"
              icon="fa-solid fa-broom"
              @click="clearAllDownloads"
            />
          </template>
          {{ $t('downloadsModal.clear_downloads') }}
        </n-tooltip>
      </div>
      <span class="text-3xl text-black-300 mr-1 mb-1">|</span>
    </template>
    <div
      v-if="downloadsStore.downloads.length === 0"
      class="mt-20 flex text-center justify-center items-center flex-col"
    >
      <div class="text-lg font-semibold">
        {{ $t('downloadsModal.keep_track') }}
      </div>
      <div class="mt-2">{{ $t('downloadsModal.downloaded_files') }}</div>
    </div>
    <div v-for="download in downloadsStore.downloads" :key="download.id">
      <n-popover
        class="border-black-300 border text-black-600"
        placement="top-end"
        trigger="hover"
        :show-arrow="false"
        :overlap="overlap"
        style="margin-right: 12px; margin-top: 13px; border-radius: 8px"
      >
        <template #trigger>
          <div
            @mouseover="mouseOver(download.id, download.file_name)"
            @mouseleave="
              mouseLeave(download.id, download.file_name, download.file_type)
            "
            class="p-3 font-medium rounded-xl border border-black-300 cursor-pointer w-150"
            @click="openInNewTab(download.file_link)"
          >
            <span class="items-center flex">
              <font-awesome-icon
                class="text-xl mr-3 mt-1"
                icon="fa-solid fa-circle-exclamation"
              />
              <span>{{ download.file_name }}</span>
            </span>
            <div :id="getDivID(download)" class="text-xs mt-1 ml-8">
              {{ download.file_type }}
            </div>
          </div>
        </template>
        <div
          class="hover:bg-black-100 mb-0 text-center rounded-md flex justify-between items-center p-2 cursor-pointer"
          @click="clearDownload(download.id)"
        >
          <font-awesome-icon icon="fa-solid fa-xmark" />
        </div>
      </n-popover>
    </div>
  </n-modal>
</template>

<script>
import { NModal, NTooltip, NPopover, NAlert } from 'naive-ui';
import {
  getDownloads,
  deleteAllDownloads,
  deleteDownload,
} from '../../api/downloads/downloads.js';
import { useDownloadsStore } from '../../stores/useDownloadsStore';
import { CONSTANTS } from '../../assets/constants';
import { ref } from 'vue';

export default {
  setup() {
    const downloadsStore = useDownloadsStore();
    return {
      overlap: ref(true),
      downloadsStore,
    };
  },
  components: {
    NModal,
    NTooltip,
    NPopover,
    NAlert,
  },
  methods: {
    clearAllDownloads() {
      try {
        deleteAllDownloads().then(response => {
          this.downloadsStore.downloads = [];
          this.downloadsStore.response = response;
          this.downloadsStore.downloadAlert = true;
        });
        this.downloadsStore.downloadAlert = false;
      } catch (error) {
        this.downloadsStore.downloadAlert = true;
      }
    },

    clearDownload(download_id) {
      try {
        deleteDownload(download_id).then(response => {
          this.downloadsStore.downloads = this.downloadsStore.downloads.filter(
            function (download) {
              return download.id != download_id;
            }
          );
          this.downloadsStore.response = response;
          this.downloadsStore.downloadAlert = true;
        });
        this.downloadsStore.downloadAlert = false;
      } catch (error) {
        this.downloadsStore.downloadAlert = true;
      }
    },

    openInNewTab(url) {
      window.open(url, '_blank', 'noreferrer');
    },

    mouseOver(download_id, file_name) {
      const download = document.getElementById(download_id + file_name);
      download.innerHTML = CONSTANTS.OPEN_FILE;
      download.classList.add('bg-black-100');
    },

    mouseLeave(download_id, file_name, type) {
      const download = document.getElementById(download_id + file_name);
      download.innerHTML = type;
      download.classList.remove('bg-black-100');
    },

    getDivID(download) {
      return download.id + download.file_name;
    },
  },

  mounted() {
    try {
      getDownloads().then(response => {
        this.downloadsStore.downloads = response.data;
      });
    } catch (error) {
      this.downloadsStore.downloadAlert = true;
    }
  },
};
</script>
