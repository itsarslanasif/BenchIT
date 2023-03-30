<template>
  <div class="h-full w-full bg-white flex flex-col items-center">
    <div class="grid grid-cols-4 items-center w-full p-3">
      <div></div>
      <div class="center-col col-span-2 justify-self-center">
        <img class="w-25 h-40" src="../../assets/images/Bench IT.png" />
      </div>
      <div class="right-col text-md">
        <p>
          {{ $t('pages.sign_up.instructions1') }}<br />
          <a class="text-woot-800" href="http://127.0.0.1:5100/sign_in">{{
            $t('pages.sign_up.sign_in_instead')
          }}</a>
        </p>
      </div>
    </div>
    <div class="">
      <div class="flex justify-center items-center h-full bg-gray-100">
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
                :disabled="!areCredsPresent"
                class="bg-slate-500 hover:bg-slate-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                type="submit"
              >
                {{ $t('pages.sign_up.signup') }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { ref, computed } from 'vue';
import { userSignUp } from '../../api/user_auth/user_sign_up_api';

export default {
  setup() {
    const email = ref('');
    const username = ref('');
    const password = ref('');

    const areCredsPresent = computed(() => {
      return (
        email.value !== '' || username.value !== '' || password.value !== ''
      );
    });

    const handleSubmit = async () => {
      await userSignUp({
        name: username.value,
        email: email.value,
        password: password.value,
      });
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
