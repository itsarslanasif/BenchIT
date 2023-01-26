<template>
  <div class="w-56 min-w-fit mb-1">
    <div
      v-if="profile"
      class="bg-white border border-black-400 cursor-pointer rounded-lg mb-4 p-0 mx-2 m-auto"
    >
      <img
        class="bg-primary rounded-lg object-cover"
        :src="profile.image_url"
        alt="Avatar"
      />
      <div class="ml-4 mt-4 flex font-medium">
        {{ profile.username }}
        {{ isOwnChat ? $t('chat.you') : '' }}
        <span class="flex mt-1 ml-2 h-3 w-3">
          <span
            v-if="profile.is_active"
            class="bg-green-700 text-black-800 h-3 w-3 border-2 border-black-800 rounded-xl"
          />
          <span
            v-else
            class="bg-white text-black-800 h-3 w-3 border-2 border-black-800 rounded-xl"
          />
        </span>
      </div>

      <p class="ml-4 mb-4 text-sm text-primary">{{ profile.description }}</p>
    </div>
  </div>
</template>

<script>
import { storeToRefs } from 'pinia';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
export default {
  props: ['profile'],
  setup() {
    const currentProfileStore = useCurrentProfileStore();
    const { currentProfile } = storeToRefs(currentProfileStore);
    return { currentProfile };
  },
  computed: {
    isOwnChat() {
      if (this.currentProfile && this.profile) {
        return this.currentProfile.id === this.profile.id;
      }
    },
  },
};
</script>
