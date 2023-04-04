<template>
  <div class="flex justify-center items-center h-full">
    <div class="w-full max-w-md bg-white p-6 rounded-lg shadow-md">
      <h1 class="text-3xl font-bold text-center text-gray-900 mb-4">
        {{ $t('pages.sign_up.join') }}
      </h1>
      <h2 class="text-lg text-center text-gray-700 mb-8">
        {{ $t('pages.sign_up.instructions2') }}
      </h2>
      <form class="mb-4" @submit.prevent="handleSubmit">
        <div class="mb-4">
          <label class="block text-gray-700 font-bold mb-2" for="email">
            {{ $t('pages.sign_up.email') }}
          </label>
          <input
            v-model="email"
            class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="email"
            type="email"
            placeholder="you@example.com"
            required
          />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-bold mb-2" for="password">
            {{ $t('pages.sign_up.password') }}
          </label>
          <input
            v-model="password"
            class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="password"
            type="password"
            placeholder="********"
            required
          />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-bold mb-2" for="username">
            {{ $t('pages.sign_up.user_name') }}
          </label>
          <input
            v-model="username"
            class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="username"
            type="text"
            placeholder="username"
            required
          />
        </div>
        <div class="mb-6">
          <label class="flex items-center">
            <input
              v-model="termsAccepted"
              class="mr-2 leading-tight"
              type="checkbox"
              required
            />
            <span class="text-sm text-gray-700">
              {{ $t('pages.sign_up.terms_services') }}
            </span>
          </label>
        </div>
        <div class="flex items-center justify-center">
          <button
            class="bg-slate-700 hover:bg-slate-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline disabled:opacity-50 disabled:cursor-not-allowed"
            type="submit"
            :disabled="!areCredsPresent"
          >
            {{ $t('pages.sign_up.signup') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
<script>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useSignUpStore } from '../../../stores/useSignUpStore';
export default {
  setup() {
    const email = ref('');
    const username = ref('');
    const password = ref('');
    const router = useRouter();

    const signUpStore = useSignUpStore();

    const areCredsPresent = computed(() => {
      return (
        email.value !== '' && username.value !== '' && password.value !== ''
      );
    });

    const handleSubmit = async () => {
      await signUpStore.signUpUser(username.value, email.value, password.value);
      router.push('/sign_up/success');
    };

    return {
      email,
      username,
      password,
      areCredsPresent,
      handleSubmit,
    };
  },
};
</script>
