<template>
  <n-modal
    v-model:show="showModal"
    class="custom-card rounded-lg w-180 h-400 overflow-y-auto overflow-x-hidden"
    preset="card"
    :bordered="false"
    size="huge"
  >
    <template #header
      ><span class="text-2xl font-bold">{{
        $t('downloadsModal.downloads')
      }}</span></template
    >
    <template #header-extra>
      <div
        class="h-8 w-8 mr-3 hover:bg-black-100 mb-0 text-center rounded-md flex justify-between items-center p-1"
      >
        <n-tooltip trigger="hover">
          <template #trigger>
            <font-awesome-icon
              class="text-xl text-black-600 cursor-pointer"
              icon="fa-solid fa-broom"
              @click="click"
            />
          </template>
          {{ $t('downloadsModal.clear_downloads') }}
        </n-tooltip>
      </div>
      <span class="text-3xl text-black-300 mr-1 mb-1">|</span>
    </template>
    <div v-for="download in downloadsStore.downloads" :key="download.id">
      <n-popover
        class="rounded-xl border-black-300 border text-black-600"
        placement="top-end"
        trigger="hover"
        :show-arrow="false"
        :overlap="overlap"
      >
        <template #trigger>
          <div
            @mouseover="mouseover(download.id, download.file_name)"
            @mouseleave="
              mouseleave(download.id, download.file_name, download.file_type)
            "
            class="p-3 font-medium rounded-xl border border-black-300 cursor-pointer w-150"
            @click="openInNewTab(download.file_link)"
          >
            <span class="items-center flex">
              <font-awesome-icon
                class="text-xl mr-3 mt-1"
                icon="fa-solid fa-circle-exclamation"
              />
              <div>{{ download.file_name }}</div>
            </span>
            <div
              :id="download.id + download.file_name"
              class="text-xs mt-1 ml-8"
            >
              {{ download.file_type }}
            </div>
          </div>
        </template>
        <div
          class="hover:bg-black-100 mb-0 text-center rounded-md flex justify-between items-center p-2 cursor-pointer"
        >
          <font-awesome-icon icon="fa-solid fa-xmark" />
        </div>
      </n-popover>
    </div>
  </n-modal>
</template>

<script>
import { NModal, NTooltip, NPopover } from 'naive-ui';
import { getDownloads } from '../../api/downloads/downloads.js';
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
  },
  methods: {
    click() {},
    openInNewTab(url) {
      window.open(url, '_blank', 'noreferrer');
    },
    mouseover(download_id, file_name) {
      const download = document.getElementById(download_id + file_name);
      download.innerHTML = CONSTANTS.OPEN_FILE;
      download.classList.add('bg-black-100');
    },
    mouseleave(download_id, file_name, type) {
      const download = document.getElementById(download_id + file_name);
      download.innerHTML = type;
      download.classList.remove('bg-black-100');
    },
  },
  async mounted() {
    this.downloadsStore.downloads = await getDownloads();
  },
};
</script>
