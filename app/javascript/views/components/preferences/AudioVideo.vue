<template lang="">
  <div>
    <p class="font-semibold">Camera</p>
    <div v-if="isCameraOpen" class="my-3">
      <video ref="camera" autoplay class="rounded"></video>
    </div>
    <hr class="my-3" />
    <div>
      <p class="font-semibold">{{ audioVideoSettings.microphone.title }}</p>
      <select class="py-3 px-10 mr-3 rounded border">
        <option v-for="item in audioVideoSettings.microphone.settings">
          {{ item.label }}
        </option>
      </select>
      <p>Input level:</p>
      <input type="checkbox" />
      <label class="px-3">Enable automatic gain control</label>
      <input type="checkbox" />
      <label class="px-3">Enable noise suppression</label>
    </div>
    <div class="mt-3">
      <p class="font-semibold">{{ audioVideoSettings.speaker.title }}</p>
      <select class="py-3 px-10 mr-3 rounded border">
        <option v-for="item in audioVideoSettings.speaker.settings">
          {{ item.label }}
        </option>
      </select>
    </div>
    <div class="mt-3">
      <p class="font-semibold">{{ audioVideoSettings.troubleshoot.title }}</p>
      <p class="text-info">{{ audioVideoSettings.troubleshoot.tagline }}</p>
    </div>
    <hr class="my-3" />
    <div class="mt-3">
      <p class="font-semibold">{{ audioVideoSettings.joinedSlack.title }}</p>
      <div v-for="item in audioVideoSettings.joinedSlack.settings" class="py-1">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <hr class="my-3" />
    <div class="mt-3">
      <p class="font-semibold">{{ audioVideoSettings.inHuddle.title }}</p>
      <div v-for="item in audioVideoSettings.inHuddle.settings" class="py-1">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <div class="mt-3">
      <p class="font-semibold">{{ audioVideoSettings.inBackground.title }}</p>
      <div
        v-for="item in audioVideoSettings.inBackground.settings"
        class="py-1"
      >
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
      <p>
        Use
        <span class="bg-black-700 text-white px-2 py-1 rounded">
          Ctrl
        </span>
        <span class="bg-black-700 text-white px-2 ml-1 py-1 rounded">
          Shift
        </span>
        +
        <span class="bg-black-700 text-white px-2 py-1 rounded">
          Space
        </span>
        to
        mute or unmute your mic.
      </p>
    </div>
    <hr class="my-5" />
    <div class="mt-3">
      <p class="font-semibold">{{ audioVideoSettings.onScreenSaver.title }}</p>
      <div v-for="item in audioVideoSettings.onScreenSaver.settings" class="py-1">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
  </div>
</template>

<script>
import { audioVideoSettings } from '../../../assets/settings/audioVideo';
export default {
  data() {
    return {
      isCameraOpen: true,
      audioVideoSettings,
    };
  },

  beforeUnmount() {
    this.isCameraOpen = false;
    this.stopCameraStream();
  },

  beforeMount() {
    this.createCameraElement();
  },

  methods: {
    createCameraElement() {
      const constraints = (window.constraints = {
        audio: true,
        video: true,
      });
      navigator.mediaDevices
        .getUserMedia(constraints)
        .then(stream => {
          this.$refs.camera.srcObject = stream;
        })
        .catch(error => {
          alert("May the browser didn't support or there is some errors.");
        });
    },

    stopCameraStream() {
      let tracks = this.$refs.camera.srcObject.getTracks();
      tracks.forEach(track => {
        track.stop();
      });
    },
  },
};
</script>
