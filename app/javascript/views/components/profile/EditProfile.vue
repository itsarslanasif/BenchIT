<template>
  <div class="w-full h-full p-3">
    <div class="w-2/5 gap-5 p-3 justify-center mx-auto text-base rounded-lg">
      <div class="p-2 font-bold text-xl">
        <label>{{ $t('edit_profile.heading') }}</label>
      </div>
      <div class="flex mb-5">
        <div class="flex flex-col gap-3 p-2 w-3/4">
          <div class="sections">
            <label>{{ $t('edit_profile.full_name') }}</label>
            <input
              type="text"
              :placeholder="$t('edit_profile.full_name')"
              class="input focus:border-primary"
              v-model="fullName"
            />
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.display_name') }}</label>
            <input
              type="text"
              :placeholder="$t('edit_profile.display_name')"
              class="input"
              v-model="displayName"
            />
            <p class="text-xs">
              {{ $t('edit_profile.display_name_desc') }}
            </p>
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.title') }}</label>
            <input
              type="text"
              :placeholder="$t('edit_profile.title')"
              class="input"
              v-model="title"
            />
            <p class="text-xs">{{ $t('edit_profile.title_desc') }}</p>
          </div>
          <div>
            <audioRecordingVue :submit="submit" />
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.name_pronounce') }}</label>
            <input
              type="text"
              :placeholder="$t('edit_profile.name_pronounce_placeholder')"
              class="input"
              v-model="namePronounciation"
            />
            <p class="text-xs">
              {{ $t('edit_profile.name_pronounce_desc') }}
            </p>
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.time_zone') }}</label>
            <select class="input" v-model="timezone">
              <option v-for="tz in timezones" :key="tz.text" class="option">
                {{ tz.text }}
              </option>
            </select>
            <p class="text-xs">
              {{ $t('edit_profile.time_zone_desc') }}
            </p>
          </div>
        </div>
        <div class="flex flex-col gap-2">
          <div class="flex w-48 h-48 mt-8">
            <img
              :src="
                currentUser.imageURL
                  ? currentUser.imageURL
                  : readerFile.length
                  ? readerFile[readerFile.length - 1]
                  : '../../../assets/images/user.png'
              "
              class="rounded-md object-cover"
            />
          </div>
          <label for="uploadFile" class="button cursor-pointer">{{
            $t('actions.upload_photo')
          }}</label>
          <input
            type="file"
            id="uploadFile"
            @change="uploadFile"
            accept="image/*"
            ref="file"
            class="hidden"
          />
          <button
            class="button border-none text-info hover:underline"
            @click="removeFile"
          >
            {{ $t('actions.remove_photo') }}
          </button>
        </div>
      </div>
      <div class="float-right mb-2 mr-3">
        <div class="flex gap-2">
          <button class="button">{{ $t('actions.cancel') }}</button>
          <button
            class="button bg-success text-white border-none"
            @click="saveChanges"
          >
            {{ $t('actions.save_changes') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { useCurrentUserStore } from '../../../stores/CurrentUserStore';
import { storeToRefs } from 'pinia';
import { timezones } from '../../../assets/timezone';
import audioRecordingVue from '../../widgets/audioRecording.vue';
export default {
  components: { audioRecordingVue },
  data() {
    return {
      timezones: timezones,
      recordingFlag: false,
      audioChunks: [],
      recordedFlag: false,
      audioRecorder: null,
      audioBlob: null,
      file: null,
      readerFile: [],
      title: this.currentUser.title ? this.currentUser.title : '',
      timezone: this.currentUser.timezone ? this.currentUser.timezone : '',
      namePronounciation: this.currentUser.namePronounciation
        ? this.currentUser.namePronounciation
        : '',
      displayName: this.currentUser.displayName
        ? this.currentUser.displayName
        : this.currentUser.name,
      fullName: this.currentUser.name,
    };
  },

  setup() {
    const CurrentUserStore = useCurrentUserStore();
    const { currentUser } = storeToRefs(CurrentUserStore);
    const constraints = { audio: true };
    let chunks = [];
    return {
      currentUser,
      constraints,
      chunks,
    };
  },
  methods: {
    uploadFile() {
      this.file = this.$refs.file.files[0];
      if (this.file.type.slice(0, 6) === 'image/') {
        const reader = new FileReader();
        reader.readAsDataURL(this.file);
        reader.onload = () => this.readerFile.push(reader.result);
      }
    },
    removeFile() {
      this.readerFile = [];
    },
    saveChanges() {
      let formData = new FormData();
      formData.append('full_name', this.fullName);
      formData.append('display_name', this.displayName);
      formData.append('title', this.title);
      formData.append('name_pronounciation', this.namePronounciation);
      formData.append('time_zone', this.timezone);
      formData.append('profile_photo', this.file);
      formData.append('audio_clip', this.audioBlob);
    },
    submit(audioChunks, audioBlob, audioRecorder) {
      this.audioChunks = audioChunks;
      this.audioBlob = audioBlob;
      this.audioRecorder = audioRecorder;
    },
  },
};
</script>
<style>
.sections {
  @apply flex flex-col gap-1;
}

.input {
  @apply p-2 rounded bg-slate-50;
}

.button {
  @apply py-1 px-3 rounded border text-center;
}
</style>
