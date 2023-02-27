<template lang="">
  <div>
    <div class="mb-10">
      <p>
        <strong>{{ languageRegion.language.title }}</strong>
      </p>
      <select class="w-full p-4 my-3">
        <option v-for="item in languageRegion.language.settings.options">
          {{ item.label }}
        </option>
      </select>
      <p>{{ languageRegion.language.tagline }}</p>
    </div>
    <div class="my-10">
      <p>
        <strong>{{ languageRegion.timezone.title }}</strong>
      </p>
      <select class="w-full p-4 my-3">
        <option v-for="item in languageRegion.timezone.settings.options">
          {{ item.label }}
        </option>
      </select>
      <p>{{ languageRegion.timezone.tagline }}</p>
    </div>
    <div class="my-10">
      <p>
        <strong>{{ languageRegion.spellCheck.title }}</strong>
      </p>
      <input
        type="text"
        class="w-full p-4 my-3"
        :value="languageRegion.spellCheck.settings.selected[0]"
      />
      <p>{{ languageRegion.spellCheck.tagline }}</p>
    </div>
  </div>
</template>

<script>
import { languageRegion } from '../../../assets/settings/languageRegion';
export default {
  data() {
    return {
      languageRegion,
    };
  },
};
</script>
