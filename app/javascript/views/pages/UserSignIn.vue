<template>
  <div v-if="response" class="relative">
    <benchit-alert
      :errorMessage="$t('pages.sign_in.error_message')"
      :successMessage="response?.message"
      :success="response?.user"
    />
  </div>
  <div class="mt-8 flex flex-col items-center justify-items-center text-center">
    <header class="w-full p-4 items-center grid grid-cols-3">
      <div class="left-col"></div>
      <div class="center-col">
        <a href="#" class="text-3xl font-semibold">
          {{ $t('project.title') }}
        </a>
      </div>
      <div class="right-col justify-items-end text-right pr-5">
        <p class="text-md font-thin">
          {{ $t('pages.sign_in.new_to_bench_it') }}
        </p>
        <a class="text-md text-woot-800" href="#">{{
          $t('pages.sign_in.create_your_account')
        }}</a>
      </div>
    </header>
    <p class="text-4xl max-w-4xl font-semibold leading-none text-center p-2">
      {{ $t('pages.sign_in.title') }}
    </p>
    <p class="text-xl font-thin p-1 mb-5">
      {{ $t('pages.sign_in.instructions_1') }}
      <b>
        {{ $t('pages.sign_in.instructions_2') }}
      </b>
    </p>
    <button class="google-btn">
      <span class="flex items-center justify-items-center justify-center">
        <font-awesome-icon
          icon="fa-brands fa-google"
          class="h-5 w-5 mr-3 text-woot-600"
        />
        <p class="text-woot-600 text-lg font-semibold">
          {{ $t('pages.sign_in.continue_with_google') }}
        </p>
      </span>
    </button>
    <button class="apple-btn">
      <span class="flex items-center justify-items-center justify-center">
        <font-awesome-icon icon="fa-brands fa-apple" class="w-5 h-5 mr-3" />
        <p class="text-lg font-semibold">
          {{ $t('pages.sign_in.continue_with_apple') }}
        </p>
      </span>
    </button>
    <n-divider class="w-100">
      <p class="text-m font-normal w-10">{{ $t('pages.sign_in.or') }}</p>
    </n-divider>
    <form class="flex flex-col" @submit.prevent="handleSubmit">
      <input
        v-model="user.email"
        type="email"
        :placeholder="$t('pages.sign_in.email_placeholder')"
        required
      />
      <input
        v-model="user.password"
        type="password"
        :placeholder="$t('pages.sign_in.password_placeholder')"
        required
      />
      <button class="sign-in-btn">
        {{ $t('pages.sign_in.sign_in_with_email') }}
      </button>
    </form>
    <p class="magic-code-text">
      {{ $t('pages.sign_in.code_for_password_free_sign_in') }}
      <a href="#" class="text-woot-900">
        {{ $t('pages.sign_in.sign_in_manually_instead') }}</a
      >
    </p>
  </div>
</template>

<script>
import { NForm, NFormItem, NInput, NButton, NDivider, NSpace } from 'naive-ui';
import { userSignIn } from '../../api/user_auth/user_sign_in_api';
import BenchitAlert from '../widgets/benchitAlert.vue';
import { useCurrentUserStore } from '../../stores/useCurrentUserStore';

export default {
  name: 'UserSignIn',
  components: {
    NForm,
    NFormItem,
    NInput,
    NButton,
    NDivider,
    NSpace,
    BenchitAlert,
  },
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
      response: null,
      currentProfile: {},
    };
  },
  beforeUnmount() {
    this.user = this.currentProfile = null;
  },

  methods: {
    handleSubmit() {
      userSignIn({
        user: this.user,
        authenticity_token: document.querySelector('meta[name="csrf-token"]')
          .content,
        commit: 'Log in',
      }).then(res => {
        if (res.headers.authorization) {
          localStorage.setItem('token', res.headers.authorization);
          localStorage.setItem('currentUser', JSON.stringify(res.data.user));
        }
        this.response = res.data;
        if (res.data?.user) {
          const currentUser = useCurrentUserStore();
          currentUser.setUser(res.data.user);
          this.goToWorkspaces();
        }
      });
    },
    goToWorkspaces() {
      this.$router.push('/workspace_dashboard');
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
