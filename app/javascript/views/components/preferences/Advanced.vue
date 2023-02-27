<template lang="">
  <div>
    <div>
      <p class="font-semibold">
        {{ advancedSettings.inputOptions.title }}
      </p>
      <div v-for="item in advancedSettings.inputOptions.settings" class="my-2">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <div>
      <p class="font-semibold">
        {{ advancedSettings.writingMessage.title }}
      </p>
      <div
        v-for="item in advancedSettings.writingMessage.settings"
        class="my-2"
      >
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <hr class="my-5" />
    <div>
      <p class="font-semibold">
        {{ advancedSettings.search.title }}
      </p>
      <div v-for="item in advancedSettings.search.settings" class="my-2">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
      <button class="w-1/2 border py-1 mb-2 rounded text-black-900 mr-5">
        Download
      </button>
      <button class="px-5 border py-1 mb-2 rounded text-black-900">
        Change
      </button>
      <p class="text-black-700 text-xs">{{ advancedSettings.search.note }}</p>
    </div>
    <hr class="my-5" />
    <div>
      <p class="font-semibold">
        {{ advancedSettings.confirmationWarning.title }}
      </p>
      <div v-for="item in advancedSettings.confirmationWarning.settings" class="my-2">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <hr class="my-5" />
    <div>
      <p class="font-semibold">
        {{ advancedSettings.otherOptions.title }}
      </p>
      <div v-for="item in advancedSettings.otherOptions.settings" class="my-2">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
  </div>
</template>

<script>
import { advancedSettings } from '../../../assets/settings/advanced';
export default {
  data() {
    return {
      advancedSettings,
    };
  },
};
</script>
