<template>
  <div class="w-full h-full p-3">
    <div
      class="w-2/5 gap-5 p-3 justify-center mx-auto text-base rounded-lg"
    >
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
              :value="currentUser.display_name ? currentUser.display_name : currentUser.name"
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
            <img src="../../../assets/images/user.png" class="rounded-md" />
          </div>
          <button class="button">{{ $t('actions.upload_photo') }}</button>
          <button class="button border-none text-info hover:underline">
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
  setup() {
    const CurrentUserStore = useCurrentUserStore()
    const { currentUser } = storeToRefs(CurrentUserStore)
    return {
      currentUser
    }
  }
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
  @apply py-1 px-3 rounded border;
}
</style>
