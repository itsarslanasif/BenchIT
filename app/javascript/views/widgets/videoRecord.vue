<template>
  <div>
    <button
      v-if="!editMessage"
      class="px-2 py-1 hover:bg-transparent rounded italic focus:outline-none"
      @click="toggleModal"
    >
      <font-awesome-icon icon="fa-video" />
    </button>
    <n-modal v-model:show="showModal">
      <n-card
        class="w-6/12"
        title="Record video clip"
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <template #header-extra>
          <font-awesome-icon
            @click="toggleModal"
            class="cursor-pointer h-5 w-5"
            icon="fa-solid fa-xmark"
          />
        </template>
        <n-divider />

        <div class="flex">
          display view recorder here Share your screen (optional)
          <video ref="videoElement" autoplay></video>
          <div v-if="recordedVideoUrl">
            <video :src="recordedVideoUrl" controls></video>
          </div>
        </div>

        <n-divider />
        <template #footer>
          <button
            class="px-2 space-x-1 py-1 float-left flex hover:bg-transparent rounded italic focus:outline-none"
            @click="stopRecording"
          >
            <font-awesome-icon class="mt-1" icon="fa-solid fa-cloud-arrow-up" />
            <span class=""> Upload Video </span>
          </button>
          <button
            class="px-2 py-1 float-right rounded italic focus:outline-none"
            :class="buttonDisabled ? 'bg-transparent' : 'bg-red-500'"
            @click="startRecording"
          >
            Record
          </button>
        </template>
      </n-card>
    </n-modal>
  </div>
</template>

<script>
import {
  NModal,
  NInput,
  NCard,
  NSpace,
  NCheckbox,
  NButton,
  NSelect,
  NForm,
  NFormItem,
  NDivider,
} from 'naive-ui';
import { ref } from 'vue';
import RecordRTC from 'recordrtc';
export default {
  props: ['editMessage'],
  components: {
    NModal,
    NInput,
    NCard,
    NSpace,
    NCheckbox,
    NButton,
    NSelect,
    NForm,
    NFormItem,
    NDivider,
  },
  data() {
    return {
      showModal: ref(false),
      buttonDisabled: ref(true),
      recordRTC: null,
      recordedVideoUrl: null,
      videoPlayer: null,
      stream: null,
    };
  },
  mounted() {
    this.stream = navigator.mediaDevices
      .getUserMedia({ video: true, audio: true })
      .then(stream => {
        // this.$refs.videoElement.srcObject = stream;
        this.recordRTC = new RecordRTC(stream, {
          type: 'video',
          mimeType: 'video/webm',
        });
      })
      .catch(error => {
        console.error('Error accessing media devices.', error);
      });
    // const videoPlayer = this.$refs.videoPlayer;
    // videoPlayer.srcObject = this.stream;
  },
  methods: {
    toggleModal() {
      this.showModal = !this.showModal;
    },
    startRecording() {
      this.recordRTC.startRecording();
    },
    stopRecording() {
      this.recordRTC.stopRecording(() => {
        const videoBlob = this.recordRTC.getBlob();
        const videoUrl = URL.createObjectURL(videoBlob);
        this.recordedVideoUrl = videoUrl;
        console.log(this.recordedVideoUrl);
      });
    },
  },
};
</script>

<style scoped></style>
