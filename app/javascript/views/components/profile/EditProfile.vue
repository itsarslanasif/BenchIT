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
              :value="currentUser.name"
            />
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.display_name') }}</label>
            <input
              type="text"
              :placeholder="$t('edit_profile.display_name')"
              class="input"
              :value="
                currentUser.display_name
                  ? currentUser.display_name
                  : currentUser.name
              "
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
            />
            <p class="text-xs">{{ $t('edit_profile.title_desc') }}</p>
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.name_pronounce') }}</label>
            <input
              type="text"
              :placeholder="$t('edit_profile.name_pronounce_placeholder')"
              class="input"
            />
            <p class="text-xs">
              {{ $t('edit_profile.name_pronounce_desc') }}
            </p>
          </div>
          <div class="sections">
            <label>{{ $t('edit_profile.time_zone') }}</label>
            <input type="text" placeholder="hello" class="input" />
            <p class="text-xs">
              {{ $t('edit_profile.time_zone_desc') }}
            </p>
          </div>
        </div>
        <div class="flex flex-col gap-2">
          <div class="flex w-48 h-48 mt-8">
            <img
              :src="
                readerFile.length
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
          <button class="button bg-success text-white border-none">
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
export default {
  data() {
    return {
      file: null,
      readerFile: [],
    };
  },
  setup() {
    const CurrentUserStore = useCurrentUserStore();
    const { currentUser } = storeToRefs(CurrentUserStore);
    return {
      currentUser,
    };
  },
  methods: {
    uploadFile() {
      this.file = this.$refs.file.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(this.file);
      reader.onload = () => this.readerFile.push(reader.result);
    },
    removeFile() {
      this.readerFile = []
    },
    saveChanges() {
      // let formData = new FormData();
      // formData.append('full_name', this.currentUser.id);
      // formData.append('display_name', this.message.replace(/<[^>]+>/g, ''));
      // formData.append('title', false);
      // formData.append('name_pronounciation', null);
      // formData.append('time_zone', this.conversation_type);
      // formData.append('conversation_id', this.id);
      // this.files.forEach(file => {
      //   formData.append('message_attachments[]', file);
      // });
    }
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
