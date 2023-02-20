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

        <div class="flex justify-center relative">
          <!-- <div v-show="!isCameraAvailable" class="video w-full bg-black-500"></div> -->
          <video
            v-show="isCameraAvailable"
            class="video2 border border-transparent rounded-lg"
            ref="previewVideoElement"
          ></video>
          <div
            class="absolute flex gap-4 p-3 border border-transparent rounded-lg bg-transparent mb-3 bottom-0"
          >
            <span @click="toggleAudio()"
              ><font-awesome-icon :icon="micIcon()"
            /></span>
            <span @click="toggleCamera()"
              ><font-awesome-icon :icon="videoIcon()"
            /></span>
            <span><font-awesome-icon icon="fa-solid fa-gear" /></span>
          </div>
          <div ref="recordVideoElement" v-if="recordedVideoUrl">
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
          <button @click="toggleCamera">Toggle Camera</button>
          <button
            class="px-2 py-1 float-right rounded italic focus:outline-none"
            :class="buttonDisabled ? 'bg-transparent' : 'bg-red-500'"
            @click="startRecording"
          >
            Record
          </button>
          <button
            class="px-2 py-1 float-right rounded italic focus:outline-none"
            @click="toggleAudio"
          >
            Toggle Audio
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
      recordStream: null,
      isCameraAvailable: ref(false),
      isAudioAvailable: ref(false),
    };
  },
  beforeUnmount() {
    console.log('unmounted');
    this.recordRTC = null;
    this.recordedVideoUrl = null;
    this.videoPlayer = null;
    this.stream = null;
  },
  mounted() {},
  methods: {
    micIcon() {
      if (!this.isAudioAvailable) {
        return 'fa-solid fa-microphone-slash';
      }
      return 'fa-solid fa-microphone';
    },
    videoIcon() {
      if (!this.isCameraAvailable) {
        return 'fa-solid fa-video-slash';
      }
      return 'fa-solid fa-video';
    },
    toggleModal() {
      this.showModal = !this.showModal;
      this.recordedVideoUrl = null;
    },
    startRecording() {
      if (!this.recordRTC) {
        this.startCamera();
      }
      this.recordRTC.startRecording();
    },
    stopRecording() {
      this.stopCamera();
      this.recordRTC.stopRecording(() => {
        const videoBlob = this.recordRTC.getBlob();
        const videoUrl = URL.createObjectURL(videoBlob);
        this.recordedVideoUrl = videoUrl;
        console.log(this.recordedVideoUrl);
      });
    },
    startCamera() {
      const constraints = {
        video: true,
        audio: this.isAudioAvailable, // use isAudioAvailable to set the audio option
      };

      // We call getUserMedia twice to create two video elements
      // One for streaming with audio off, and one for recording with toggleable audio
      navigator.mediaDevices
        .getUserMedia({ video: true, audio: false })
        .then(stream => {
          // Create the video element to stream with audio off
          this.stream = stream;
          this.$refs.previewVideoElement.srcObject = stream;
          this.$refs.previewVideoElement.play();
        })
        .catch(error => {
          console.error(error);
        });

      // Create the RecordRTC instance for recording with toggleable audio
      navigator.mediaDevices
        .getUserMedia(constraints)
        .then(stream => {
          this.recordRTC = new RecordRTC(stream, {
            type: 'video',
            mimeType: 'video/webm',
          });
          this.recordStream = stream;
          this.isCameraAvailable = true;
        })
        .catch(error => {
          console.error(error);
        });
    },

    toggleAudio() {
      this.isAudioAvailable = !this.isAudioAvailable;
      console.log(!this.isAudioAvailable);
      var audioTrack = this.recordStream.getAudioTracks()[0];
      if (this.isAudioAvailable) {
        audioTrack.enabled = true;
      } else {
        audioTrack.enabled = false;
      }
    },

    stopCamera() {
      this.stream.getTracks().forEach(track => track.stop());
      this.stream = null;
      this.isCameraAvailable = false;
    },
    toggleCamera() {
      if (this.stream) {
        this.stopCamera();
      } else {
        this.startCamera();
      }
    },
  },
};
</script>

<style scoped>
.video {
  height: 580px;
}
.video2 {
  width: 100%;
  height: auto;
}
</style>
