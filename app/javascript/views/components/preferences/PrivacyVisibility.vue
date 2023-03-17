<template lang="">
  <div>
    <div>
      <p class="font-semibold">
        {{ privacyVisibilitySettings.title }}
        <span
          class="text-xs ml-5 py-1 bg-info text-white px-3 rounded font-normal"
        >
          COMING SOON
        </span>
      </p>
      <p>{{ privacyVisibilitySettings.tagline }}</p>
      <div
        v-for="item in privacyVisibilitySettings.canFind.settings"
        class="my-2"
      >
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <div class="mt-5 bg-gray-100 border-2 p-5 border-black-500 rounded">
      <p class="font-semibold">
        {{ privacyVisibilitySettings.preferences.title }}
      </p>
      <p>
        {{ privacyVisibilitySettings.preferences.description }}
        <span class="text-info">
          {{ privacyVisibilitySettings.preferences.findMyWorkspace }}
        </span>
      </p>
    </div>
    <hr class="my-5" />
    <div>
      <p class="font-semibold">
        {{ privacyVisibilitySettings.contactSharing.title }}
      </p>
      <p>
        {{ privacyVisibilitySettings.contactSharing.tagline }}
        <span class="text-info"> Learn More </span>
      </p>
      <div
        v-for="item in privacyVisibilitySettings.contactSharing.settings"
        class="my-2"
      >
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <hr class="my-5" />
    <div>
      <p class="font-semibold">
        {{ privacyVisibilitySettings.invitation.title }}
      </p>
      <p>
        {{ privacyVisibilitySettings.invitation.tagline }}
      </p>
      <div class="mt-5 bg-gray-100 border-2 p-5 border-black-500 rounded">
        <p>
          {{ privacyVisibilitySettings.invitation.zeroBlocked }}
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import { privacyVisibilitySettings } from '../../../assets/settings/privacyVisibility';
export default {
  data() {
    return {
      privacyVisibilitySettings,
    };
  },
};
</script>
