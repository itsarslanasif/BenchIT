<template>
  <div class="w-56 min-w-fit mb-1">
    <div
      class="bg-white border border-black-400 cursor-pointer rounded-lg mb-4 p-0 mx-2 m-auto"
    >
      <img
        class="bg-primary rounded-lg object-cover"
        :src="profile?.image_url"
        alt="Avatar"
      />
      <p class="ml-4 mt-4 font-medium">
        {{ profile?.username }}
        {{ isOwnChat ? $t('chat.you') : '' }}
      </p>
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
      return this.currentProfile?.id === this.profile?.id;
    },
  },
};
</script>
