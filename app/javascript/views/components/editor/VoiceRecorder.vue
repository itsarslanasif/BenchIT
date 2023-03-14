<template>
  <div class="relative flex gap-1">
    <button
      v-if="!recording"
      @click="startRecording"
      class="px-2 py-1 hover:bg-transparent hover:cursor-pointer rounded focus:outline-none focus:bg-black-300"
    >
      <font-awesome-icon icon="fa-microphone" />
    </button>
    <button
      :disabled="!validRecordingTime"
      v-if="recording"
      @click="stopRecording"
      :class="!validRecordingTime && 'bg-black-300 hover:bg-black-400'"
      class="px-2 py-1 text-white bg-primary hover:bg-primaryHover hover:cursor-pointer rounded focus:outline-none focus:bg-black-300"
    >
      <font-awesome-icon icon="fa-check" />
    </button>
    <span
      v-if="recording"
      class="flex gap-1 bg-transparent rounded absolute bottom-0 my-8 -ml-6 px-2 py-1 border border-transparent shadow-inner z-10 text-xs"
    >
      <p>{{ $t('voice_mail.recording') }}</p>
      <p>{{ formattedRecordingTime }}</p>
    </span>
  </div>
</template>

<script>
import RecordRTC from 'recordrtc';
import { errorHandler } from '../../widgets/messageProvider';

export default {
  props: ['getAudio'],
  data() {
    return {
      recordRTC: null,
      stream: null,
      recording: false,
      recordingTime: 0,
    };
  },
  beforeUnmount() {
    this.recordRTC = null;
    this.recordingTime = 0;
  },
  methods: {
    startRecording() {
      this.stream = navigator.mediaDevices
        .getUserMedia({ audio: true })
        .then(stream => {
          this.recordRTC = new RecordRTC(stream, {
            type: 'audio',
            mimeType: 'audio/wav',
          });
          this.audioURL = null;
          this.recording = true;
          this.recordRTC.startRecording();
          setInterval(() => {
            this.recordingTime += 1;
          }, 1000);
        })
        .catch(e => {
          errorHandler(e.response.data.message)
        });
    },
    stopRecording() {
      this.recordRTC.stopRecording(() => {
        const audioBlob = this.recordRTC.getBlob();
        this.recordRTC = null;
        clearInterval();
        this.recordingTime = 0;
        this.recording = false;
        this.getAudio(audioBlob);
      });
      this.stream = null;
    },
  },
  computed: {
    formattedRecordingTime() {
      const minutes = Math.floor(this.recordingTime / 60);
      const seconds = this.recordingTime % 60;
      return `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
    },
    validRecordingTime() {
      return this.recordingTime > 2;
    },
  },
};
</script>
