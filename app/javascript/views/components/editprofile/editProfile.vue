<template>
  <div class="w-auto h-full p-3 bg-white rounded">
    <div class="gap-5 p-3 justify-center mx-auto text-base rounded-lg">
      <div class="p-2 font-bold text-xl">
        <label>{{ $t('edit_profile.heading') }}</label>
      </div>
      <div class="flex mb-5">
        <div class="flex flex-col gap-3 p-2 w-3/4">
          <div class="sections">
            <label>{{ $t('edit_profile.full_name') }}</label>
            <input
              type="text"
              :class="
                fullName.length < 50 && fullName.length ? 'success' : 'error'
              "
              :placeholder="$t('edit_profile.full_name')"
              class="input"
              v-model="fullName"
            />
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.display_name') }}</label>
            <input
              type="text"
              :class="
                displayName.length < 50 && displayName.length
                  ? 'success'
                  : 'error'
              "
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
              :class="title.length < 50 && title.length ? 'success' : 'error'"
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
              :class="
                namePronounciation.length < 20 && namePronounciation.length
                  ? 'success'
                  : 'error'
              "
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
                readerFile.length ? readerFile[readerFile.length - 1] : image
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
          <button class="button" @click="toggleEditProfile">
            {{ $t('actions.cancel') }}
          </button>
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
import { useCurrentUserStore } from '../../../stores/useCurrentUserStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { storeToRefs } from 'pinia';
import { timezones } from '../../../assets/timezone';
import audioRecordingVue from '../../widgets/audioRecording/audioRecording.vue';
import { useProfileStore } from '../../../stores/useProfileStore';

export default {
  props: ['toggleEditProfile'],
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
      image: this.currentProfile.image_url,
      readerFile: [],
      title: this.currentProfile.description
        ? this.currentProfile.description
        : '',
      timezone: this.currentProfile.timezone
        ? this.currentProfile.timezone
        : '',
      namePronounciation: this.currentProfile.pronounce_name
        ? this.currentProfile.pronounce_name
        : '',
      displayName: this.currentProfile.display_name
        ? this.currentProfile.display_name
        : this.currentProfile.username,
      fullName: this.currentProfile.username,
    };
  },

  setup() {
    const CurrentUserStore = useCurrentUserStore();
    const currentProfileStore = useCurrentProfileStore();
    const profileStore = useProfileStore();
    const { currentUser } = storeToRefs(CurrentUserStore);
    const { currentProfile } = storeToRefs(currentProfileStore);
    const constraints = { audio: true };
    let chunks = [];
    return {
      currentUser,
      constraints,
      chunks,
      currentProfile,
      profileStore,
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
      this.image = this.file;
    },
    removeFile() {
      this.readerFile = [];
      this.image = '../../../assets/images/user.png';
    },
    saveChanges() {
      let formData = new FormData();
      if (this.fullName.length && this.fullName.length < 50) {
        formData.append('username', this.fullName);
      }
      if (this.displayName.length && this.displayName.length < 50) {
        formData.append('display_name', this.displayName);
      }
      if (this.title.length && this.title.length < 50) {
        formData.append('title', this.title);
      }
      if (
        this.namePronounciation.length &&
        this.namePronounciation.length < 20
      ) {
        formData.append('pronounce_name', this.namePronounciation);
      }
      if (this.audioBlob) {
        formData.append('recording', this.audioBlob);
      }
      if (this.image !== this.currentProfile.image_url){
        formData.append('profile_image', this.image);
      }
      formData.append('time_zone', this.timezone);
      this.profileStore.updateProfile(formData)
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

.error {
  @apply border-danger border;
}

.success {
  @apply border-success border;
}
</style>
