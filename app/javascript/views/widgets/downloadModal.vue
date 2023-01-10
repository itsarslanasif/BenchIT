<template>
  <n-modal
    v-model:show="showModal"
    class="custom-card rounded-lg w-180 h-400 overflow-y-auto scrollable overflow-x-hidden"
    preset="card"
    :bordered="false"
    size="huge"
  >
    <template #header
      ><span class="text-2xl font-bold">Downloads</span></template
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
          Clear Downloads
        </n-tooltip>
      </div>
      <span class="text-3xl text-black-300 mr-1 mb-1">|</span>
    </template>
    <div
      v-for="download in downloads"
      :key="download.id"
    >
      <n-popover
        class="rounded-xl border-black-300 border text-black-600"
        placement="right"
        trigger="hover"
        :show-arrow="false"
        :overlap="overlap"
      >
        <template #trigger>
          <div
            class="inline-grid p-3 font-medium rounded-xl border border-black-300 cursor-pointer w-150"
            @click="openInNewTab(download.file_link)"
          >
            <span>{{ download.file_name }}</span>
            <span>{{ download.file_type }}</span>
          </div>
        </template>
        <span>X</span>
      </n-popover>
    </div>
  </n-modal>
</template>

<script>
import { NModal, NTooltip, NPopover } from 'naive-ui';
import { getDownloads } from '../../api/downloads/downloads.js';
import { ref } from 'vue';
export default {
  setup () {
    return {
      overlap: ref(true)
    }
  },
  data() {
    return {
      downloads: [],
      hover: false,
    };
  },
  components: {
    NModal,
    NTooltip,
    NPopover,
  },
  methods: {
    click() {
      console.log('Clicked');
    },
    openInNewTab(url) {
      window.open(url, '_blank', 'noreferrer');
    },
  },
  async mounted() {
    this.downloads = await getDownloads();
  },
};
</script>
