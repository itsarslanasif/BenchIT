<template>
  <div
    class="flex py-1 px-1 items-center w-90 border border-black-300 rounded-xl"
  >
    <span class="p-1">
      <button
        @click="toggleAudio"
        class="p-1 px-2 text-white hover:bg-infoHover hover:cursor-pointer rounded-full bg-info focus:outline-none"
      >
        <font-awesome-icon
          v-if="!isPlaying"
          class="h-3 w-3 self-center text-center"
          icon="fa-play"
        />
        <font-awesome-icon
          v-else
          class="h-3 w-3 self-center text-center"
          icon="fa-pause"
        />
      </button>
    </span>

    <span class="p-1 flex-grow">
      <div ref="waveform"></div>
    </span>

    <span class="w-10 ml-1 text-xs self-center p-1">
      <p :id="`timer${fileID}`">
        {{ isPlaying ? '' : formattedDuration }}
      </p>
    </span>
  </div>
</template>

<script>
import WaveSurfer from 'wavesurfer.js';

export default {
  props: ['fileID', 'audioURL'],
  data() {
    return {
      wavesurfer: null,
      audioDuration: 0,
      isPlaying: false,
    };
  },
  mounted() {
    this.wavesurfer = WaveSurfer.create({
      container: this.$refs.waveform,
      waveColor: '#41AAC4',
      waveHeight: 0,
      waveWidth: 10,
      progressColor: 'grey',
      cursorHeight: 1,
      cursorWidth: 1,
      height: 50,
      width: 100,
    });

    this.wavesurfer.load(this.audioURL);

    this.wavesurfer.on('ready', () => {
      this.audioDuration = Math.round(this.wavesurfer.getDuration());
    });
    this.wavesurfer.on('play', () => {
      const timer = document.querySelector(`#timer${this.fileID}`);
      setInterval(() => {
        const currentTime = this.wavesurfer.getCurrentTime();
        const minutes = Math.floor(currentTime / 60);
        const seconds = Math.round(currentTime % 60);
        timer.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
      }, 1000);
      this.isPlaying = true;
    });
    this.wavesurfer.on('pause', () => {
      this.isPlaying = false;
      clearInterval();
    });
    this.wavesurfer.on('finish', () => {
      this.isPlaying = false;
      clearInterval();
    });
  },
  methods: {
    toggleAudio() {
      if (this.isPlaying) {
        this.wavesurfer.pause();
      } else {
        this.wavesurfer.play();
      }
    },
  },
  computed: {
    formattedDuration() {
      const minutes = Math.floor(this.audioDuration / 60);
      const seconds = this.audioDuration % 60;
      return `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
    },
  },
};
</script>
