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
          <video
            v-show="!isCameraAvailable && !recordedVideoUrl"
            class="w-flexible-xl h-flexible-xl bg-black-900 border border-transparent rounded-lg"
          ></video>
          <video
            v-show="isCameraAvailable && !recordedVideoUrl"
            class="w-flexible-xl h-flexible-xl border border-transparent rounded-lg"
            ref="previewVideoElement"
          ></video>
          <div
            ref="recordVideoElement"
            class="flex items-center w-flexible-xl h-flexible-xl justify-center"
            v-if="recordedVideoUrl"
          >
            <video
              class="border border-transparent rounded-lg bg-transparent"
              :src="recordedVideoUrl"
              controls
            ></video>
          </div>
          <div
            class="absolute flex gap-4 p-3 border border-transparent rounded-lg bg-transparent mb-3 bottom-0"
            v-if="!recordedVideoUrl"
          >
            <span
              @click="toggleAudio()"
              class="flex items-center justify-center w-4 h-4"
              ><font-awesome-icon class="" :icon="micIcon()"
            /></span>
            <span
              class="flex items-center justify-center w-4 h-4"
              @click="toggleCamera()"
              ><font-awesome-icon :icon="videoIcon()"
            /></span>
            <span class="flex items-center justify-center w-4 h-4"
              ><font-awesome-icon icon="fa-solid fa-gear"
            /></span>
            <span
              v-show="recording || recordingPaused"
              class="flex items-center justify-center w-4 h-4"
            >
              <font-awesome-icon
                @click="togglePauseRecording()"
                :class="recording ? 'text-red-500' : 'text-black-800'"
                :icon="recordingIcon()"
            /></span>
            <!-- <span class="flex items-center justify-center w-4 h-4"
              ><font-awesome-icon icon="fa-solid fa-trash"
            /></span> -->
          </div>
        </div>

        <n-divider />
        <template #footer>
          <button
            class="px-2 space-x-1 py-1 float-left flex hover:bg-transparent rounded focus:outline-none"
            @click="stopRecording"
          >
            <font-awesome-icon class="mt-1" icon="fa-solid fa-cloud-arrow-up" />
            <span class=""> Upload Video </span>
          </button>

          <div class="float-right flex gap-2 px-2 py-1">
            <button
              v-show="recordedVideoUrl"
              class="px-2 py-1 rounded hover:bg-red-400 bg-red-300 text-white focus:outline-none"
              @click="cancelRecording"
            >
              start over
            </button>
            <button
              class="px-2 py-1 float-right hover:bg-secondaryHover bg-secondary text-white rounded focus:outline-none"
              @click="handleActionButton"
            >
              {{ recordButton }}
            </button>
          </div>
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
      isCameraAvailable: ref(true),
      isAudioAvailable: ref(true),
      recording: ref(false),
      recordingPaused: ref(false),
      status: ref('inactive'),
    };
  },
  beforeUnmount() {
    console.log('unmounted');
    this.recordRTC = null;
    this.recordedVideoUrl = null;
    this.videoPlayer = null;
    this.recordStream = null;
    this.stream = null;
  },
  mounted() {
    this.recordRTC = null;
    this.recordedVideoUrl = null;
    this.videoPlayer = null;
    this.recordStream = null;
    this.stream = null;
  },
  computed: {
    recordButton() {
      if (this.recording && !this.recordingPaused) {
        this.status = 'recording';
        return 'Stop';
      }
      if (!this.recording && !this.recordingPaused && !this.recordedVideoUrl) {
        console.log('asdasdasdasd', this.recordedVideoUrl);
        this.status = 'inactive';
        return 'Record';
      }
      if (this.recordedVideoUrl) {
        this.status = 'recorded';
        console.log('asdasdasdasd', this.recordedVideoUrl, this.status);
        return 'Done';
      }
      if (this.recordingPaused) {
        return 'Stop';
      }
    },
    buttonDisabled() {
      if (!this.recordedVideoUrl) {
        return true;
      } else {
        return false;
      }
    },
  },
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
    recordingIcon() {
      if (this.recording) {
        return 'fa-solid fa-record-vinyl';
      } else if (this.recordingPaused) {
        return 'fa-solid fa-pause';
      }
    },
    toggleModal() {
      this.showModal = !this.showModal;
      this.recordedVideoUrl = null;
      this.recordRTC = null;
      this.recordedVideoUrl = null;
      this.videoPlayer = null;
      this.stream = null;
      this.recordStream = null;
      this.isAudioAvailable = true;
      this.isCameraAvailable = false;
      this.recordingPaused = false;
      this.recording = false;
    },
    startRecording() {
      if (!this.recordRTC) {
        this.startCamera();
      }
      this.recording = true;
      this.recordRTC.startRecording();
    },
    cancelRecording() {
      this.recordedVideoUrl = null;
    },
    handleActionButton() {
      if (this.isCameraAvailable) {
        if (this.status == 'inactive') {
          this.startRecording();
        } else if (this.status == 'recorded') {
          console.log('send..........');
        } else if (this.status == 'recording') {
          this.stopRecording();
        }
      }
    },
    togglePauseRecording() {
      console.log('running ');
      if (this.recording) {
        this.recordRTC.pauseRecording();
        this.recordingPaused = true;
        this.recording = false;
      } else {
        this.recordRTC.resumeRecording();
        this.recordingPaused = false;
        this.recording = true;
      }
    },
    stopRecording() {
      this.stopCamera();
      this.recording = false;
      this.pauseRecording = false;
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
        this.stream = null;
        this.recordStream = null;
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
