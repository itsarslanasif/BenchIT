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
              ><font-awesome-icon class="" :icon="micIcon"
            /></span>
            <span
              v-show="toggleCameraButton"
              class="flex items-center justify-center w-4 h-4"
              @click="toggleCamera()"
              ><font-awesome-icon :icon="videoIcon"
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
                :icon="recordingIcon"
            /></span>
          </div>
        </div>

        <template #footer>
          <button
            class="px-2 space-x-1 py-2 float-left flex hover:bg-transparent rounded focus:outline-none"
            @click="selectFile"
          >
            <font-awesome-icon class="mt-1" icon="fa-solid fa-cloud-arrow-up" />
            <span>
              {{ $t('video_recording.upload_video') }}
              <input
                class="ml-2"
                type="file"
                ref="fileInput"
                style="display: none"
                @change="handleFileUpload"
                accept="video/*"
              />
            </span>
          </button>

          <button
            class="px-2 space-x-1 py-2 ml-5 float-left flex hover:bg-transparent rounded focus:outline-none"
            @click="toggleScreenRecording"
          >
            <font-awesome-icon class="mt-1" icon="fa-solid fa-display" />
            <span> {{ $t('video_recording.screen_record') }}</span>
          </button>

          <div class="float-right flex gap-2 px-2 py-1">
            <button
              v-show="recordedVideoUrl"
              class="px-2 py-1 rounded hover:bg-red-400 bg-red-300 text-white focus:outline-none"
              @click="cancelRecording"
            >
              {{ $t('video_recording.start_over') }}
            </button>
            <button
              class="px-2 py-1 float-right hover:bg-secondary bg-secondaryHover text-white rounded focus:outline-none"
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
  props: ['editMessage', 'getVideoFiles'],
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
      recordRTC: null,
      recordedVideoUrl: null,
      videoFile: null,
      videoPlayer: null,
      stream: null,
      recordStream: null,
      isCameraAvailable: ref(true),
      isAudioAvailable: ref(true),
      recording: ref(false),
      recordingPaused: ref(false),
      status: ref(this.$t('video_recording.inactive')),
      screenRecord: ref(false),
    };
  },
  beforeUnmount() {
    this.recordRTC = null;
    this.recordedVideoUrl = null;
    this.videoPlayer = null;
    this.recordStream = null;
    this.stream = null;
  },
  mounted() {
    this.recordRTC = null;
    this.recordedVideoUrl = null;
    this.videoFile = null;
    this.videoPlayer = null;
    this.recordStream = null;
    this.stream = null;
  },
  computed: {
    recordButton() {
      if (this.recordedVideoUrl) {
        this.status = this.$t('video_recording.recorded');
        return this.$t('video_recording.done');
      }
      if (this.recordingPaused || (this.recording && !this.recordingPaused)) {
        this.status = this.$t('video_recording.recording');
        return this.$t('video_recording.stop');
      }
      this.status = this.$t('video_recording.inactive');
      return this.$t('video_recording.record');
    },

    toggleCameraButton() {
      return this.screenRecord ||
        this.status === this.$t('video_recording.recording')
        ? false
        : true;
    },

    recordingIcon() {
      return this.recording
        ? 'fa-solid fa-record-vinyl'
        : this.recordingPaused
        ? 'fa-solid fa-pause'
        : '';
    },

    micIcon() {
      return this.isAudioAvailable
        ? 'fa-solid fa-microphone'
        : 'fa-solid fa-microphone-slash';
    },
    videoIcon() {
      return this.isCameraAvailable
        ? 'fa-solid fa-video'
        : 'fa-solid fa-video-slash';
    },
  },
  methods: {
    handleFileUpload() {
      const file = this.$refs.fileInput.files[0];
      if (file) {
        this.videoFile = file;
        this.recordedVideoUrl = URL.createObjectURL(file);
        this.status = this.$t('video_recording.recorded');
      }
    },

    selectFile() {
      this.$refs.fileInput.click();
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
      this.videoFile = null;
      this.$refs.fileInput.value = '';
    },

    handleActionButton() {
      switch (this.status) {
        case this.$t('video_recording.inactive'):
          this.startRecording();
          break;
        case this.$t('video_recording.recorded'):
          this.getVideoFiles(this.videoFile);
          this.toggleModal();
          break;
        case this.$t('video_recording.recording'):
          this.stopRecording();
          break;
      }
    },

    stopRecording() {
      this.stopCamera();
      this.recording = false;
      this.pauseRecording = false;
      this.screenRecord = false;
      this.recordRTC.stopRecording(() => {
        const videoBlob = this.recordRTC.getBlob();
        this.videoFile = videoBlob;
        const videoUrl = URL.createObjectURL(videoBlob);
        this.recordedVideoUrl = videoUrl;
      });
    },

    async startCamera() {
      const constraints = {
        video: true,
        audio: this.isAudioAvailable,
      };
      if (!this.screenRecord) {
        await navigator.mediaDevices
          .getUserMedia({ video: true, audio: false })
          .then(stream => {
            this.stream = stream;
            this.$refs.previewVideoElement.srcObject = stream;
            this.$refs.previewVideoElement.play();
          })
          .catch(error => {
            console.error(error);
          });
        await navigator.mediaDevices
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
      } else {
        await navigator.mediaDevices
          .getDisplayMedia({ video: true, audio: true })
          .then(stream => {
            this.recordRTC = new RecordRTC(stream, {
              type: 'video',
              mimeType: 'video/webm',
            });
            this.recordStream = stream;
            this.stream = stream;
            this.$refs.previewVideoElement.srcObject = stream;
            this.$refs.previewVideoElement.play();
            this.isCameraAvailable = true;
            this.screenRecord = true;
          })
          .catch(error => {
            console.error(error);
          });
      }
    },

    toggleModal() {
      this.showModal = !this.showModal;
      this.recordedVideoUrl = null;
      this.recordRTC = null;
      this.videoFile = null;
      this.videoPlayer = null;
      this.stream = null;
      this.recordStream = null;
      this.isAudioAvailable = true;
      this.isCameraAvailable = false;
      this.recordingPaused = false;
      this.recording = false;
    },

    stopCamera() {
      this.stream.getTracks().forEach(track => track.stop());
      this.stream = null;
      this.isCameraAvailable = false;
    },

    toggleScreenRecording() {
      this.screenRecord = !this.screenRecord;
      this.startCamera();
    },

    togglePauseRecording() {
      this.recordingPaused = !this.recordingPaused;
      this.recording
        ? this.recordRTC.pauseRecording()
        : this.recordRTC.resumeRecording();
      this.recording = !this.recordingPaused;
    },

    toggleAudio() {
      this.isAudioAvailable = !this.isAudioAvailable;
      const audioTrack = this.recordStream.getAudioTracks()[0];
      audioTrack.enabled = this.isAudioAvailable;
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
