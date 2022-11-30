<template>
  <div class="mt-8 flex flex-col items-center justify-items-center text-center">
    <header class="w-full p-4 items-center grid grid-cols-3">
      <div class="left-col"></div>
      <div class="center-col">
        <a href="#" class="text-3xl font-semibold">
          {{ CONSTANTS.PROJECT_NAME }}
        </a>
      </div>
      <div class="right-col justify-items-end text-right pr-5">
        <p class="text-md font-thin">{{ CONSTANTS.NEW_TO_BENCH_IT }}</p>
        <a class="text-md text-woot-800" href="#">{{ CONSTANTS.CREATE_YOUR_ACCOUNT }}</a>
      </div>
    </header>
    <p class="text-4xl max-w-4xl font-semibold leading-none text-center p-2">
      {{ CONSTANTS.SIGN_IN_TO_BENCH_IT }}
    </p>
    <p class="text-xl font-thin p-1 mb-5">
      {{ CONSTANTS.INSTRUCTION_ON_SIGN_IN_PAGE_1 }}
      <b>
        {{ CONSTANTS.INSTRUCTION_ON_SIGN_IN_PAGE_2 }}
      </b>
    </p>
    <button class="google-btn">
      <span class="flex items-center justify-items-center justify-center">
        <font-awesome-icon
          icon="fa-brands fa-google"
          class="h-5 w-5 mr-3 text-woot-600"
        />
        <p class="text-woot-600 text-lg font-semibold">
          {{ CONSTANTS.CONTINUE_WITH_GOOGLE }}
        </p>
      </span>
    </button>
    <button class="apple-btn">
      <span class="flex items-center justify-items-center justify-center">
        <font-awesome-icon icon="fa-brands fa-apple" class="w-5 h-5 mr-3" />
        <p class="text-lg font-semibold">{{ CONSTANTS.CONTINUE_WITH_APPLE }}</p>
      </span>
    </button>
    <n-divider class="w-100">
      <p class="text-m font-normal w-10">{{ CONSTANTS.OR }}</p>
    </n-divider>
    <form class="flex flex-col" @submit.prevent="handleSubmit">
      <input
        v-model="user.email"
        type="email"
        :placeholder="CONSTANTS.EMAIL_PLACEHOLDER"
        required
      />
      <button class="sign-in-btn">
        {{ CONSTANTS.SIGN_IN_WITH_EMAIL }}
      </button>
    </form>
    <p class="magic-code-text">
      {{ CONSTANTS.CODE_FOR_PASSWORD_FREE_SIGN_IN }}
      <a href="#" class="text-woot-900">
        {{ CONSTANTS.SIGN_IN_MANUALLY_INSTEAD }}</a
      >
    </p>
  </div>
</template>

<script>
import { CONSTANTS } from '../../assets/constants.js';
import { NForm, NFormItem, NInput, NButton, NDivider } from 'naive-ui';
import { userSignIn } from '../../api/user_sign_in/user_sign_in_api';
export default {
  name: 'UserSignIn',
  components: { NForm, NFormItem, NInput, NButton, NDivider },
  data() {
    return {
      CONSTANTS: CONSTANTS,
      user: {
        email: '',
      },
    };
  },
  methods: {
    async handleSubmit() {
      const response = await userSignIn({
        user: this.user,
        authenticity_token: document.querySelector('meta[name="csrf-token"]')
          .content,
      });
      console.log(response);
    },
  },
};
</script>
<style scoped>
input {
  @apply my-2 h-12 w-100 p-3 rounded border text-lg;
}

input:hover {
  @apply shadow-outline;
}

.sign-in-btn {
  @apply bg-success text-white w-100 p-2 my-2 text-xl rounded;
}

.sign-in-btn:hover {
  @apply bg-successHover;
}

.google-btn {
  @apply my-2 rounded border-2 border-woot-600 w-100 p-1;
}

.apple-btn {
  @apply my-2 rounded border-2 w-100 p-1;
}

.google-btn:hover,
.apple-btn:hover {
  @apply shadow-lg;
}

.magic-code-text {
  @apply bg-transparent text-left p-6 my-5 w-100 text-black-600 rounded-lg;
}
</style>
