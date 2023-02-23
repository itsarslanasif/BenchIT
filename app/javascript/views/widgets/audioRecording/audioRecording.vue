<template>
  <div>
    <div class="flex gap-2">
      <button @click="recording" class="button">
        <div v-if="!recordingFlag">
          {{ $t('edit_profile.record_audio_clip') }}
        </div>
        <div v-else>
          {{ $t('edit_profile.stop_recording') }}
        </div>
      </button>
      <div>
        <button @click="playRecording" class="p-2 border rounded">
          {{ $t('edit_profile.play') }}
        </button>
      </div>
      <div class="text-success font hover:bg-slate-50" @click="saveAudio">
        <font-awesome-icon icon="fa-check" />
      </div>
      <div class="text-danger font hover:bg-slate-50" @click="deleteRecording">
        <font-awesome-icon icon="fa-trash" />
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['submit'],
  data() {
    return {
      recordingFlag: false,
      audioBlob: null,
      audioChunks: [],
      audioRecorder: null,
    };
  },
  methods: {
    recording() {
      this.recordingFlag = !this.recordingFlag;
      this.recordedFlag = !this.recordedFlag;
      if (this.recordingFlag) {
        this.startRecording();
      } else {
        this.stopRecording();
      }
    },
    startRecording() {
      navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
        this.audioRecorder = new MediaRecorder(stream);
        this.audioRecorder.start();
        this.audioRecorder.addEventListener('dataavailable', event => {
          this.audioChunks.push(event.data);
        });
        this.audioRecorder.addEventListener('stop', () => {
          this.audioBlob = new Blob(this.audioChunks);
        });
      });
    },
    stopRecording() {
      this.audioRecorder.stop();
    },
    playRecording() {
      const audioUrl = window.URL.createObjectURL(this.audioBlob);
      const audio = new Audio(audioUrl);
      audio.play();
    },
    deleteRecording() {
      this.recordingFlag = false;
      this.audioBlob = null;
      this.audioChunks = [];
      this.audioRecorder = null;
    },
    saveAudio() {
      this.submit(this.audioChunks, this.audioBlob, this.audioRecorder);
    },
  },
};
</script>
<style>
.font {
  @apply p-2 text-lg rounded cursor-pointer;
}
</style>
