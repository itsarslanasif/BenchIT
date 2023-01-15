<template>
  <n-modal
    v-model:show="showModal"
    class="custom-card rounded-lg w-180"
    preset="card"
    :bordered="false"
    size="huge"
  >
    <template #header>{{ $t('rightpane.edit_about_me') }}</template>
    <form @submit.prevent="saveChanges">
      <label class="flex">{{ $t('rightpane.skype') }}</label>
      <input
        v-model="skype"
        type="phone-number"
        class="border border-black-400 rounded w-150 text-black-900 mt-2 h-12 p-3 focus:outline-none focus:bg-transparent"
      />
      <p class="text-black-500 text-sm mt-2">
        {{ $t('rightpane.displayed_on_your_profile') }}
      </p>
      <button
        @click="saveChanges"
        class="bg-green-700 font-semibold text-white mt-8 float-right border px-4 h-9 rounded hover:bg-green-800 focus:outline-none"
      >
        {{ $t('actions.save_changes') }}
      </button>
      <button
        @click="toggleModal"
        class="bg-white font-semibold text-black mt-8 mr-3 float-right border px-4 h-9 rounded hover:bg-transparent focus:outline-none"
      >
        {{ $t('actions.cancel') }}
      </button>
    </form>
  </n-modal>
</template>

<script>
import { NModal } from 'naive-ui';
export default {
  components: { NModal },
  props: {
    userAboutMe: {
      type: Object,
      default: undefined,
    },
    toggleModal: {
      type: Function,
      default: undefined,
    },
  },
  data() {
    return {
      skype: '',
    };
  },
  mounted() {
    this.setAboutMe();
  },
  beforeUnmount() {
    this.skype = null;
  },
  methods: {
    setAboutMe() {
      this.skype = this.userAboutMe.skype;
    },
    saveChanges() {
      this.userAboutMe.skype = this.skype;
      this.toggleModal();
    },
  },
};
</script>
