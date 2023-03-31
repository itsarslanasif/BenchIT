<template>
  <div
    v-if="signUpStore.isformSubmitted"
    class="flex flex-col justify-between flex-grow"
  >
    <div class="flex flex-col justify-center items-center">
      <h1 class="text-4xl font-bold text-center mb-4">
        {{ $t('pages.sign_up.confirm_email') }}
      </h1>
      <h2 class="text-lg text-center mb-8">
        {{ $t('pages.sign_up.sent_email_to') }}
        <span class="text-woot-300"> {{ signUpStore.email }} </span>
      </h2>
      <img src="../../../assets/images/verify_email.png" class="my-auto" />
    </div>
    <footer class="flex justify-between items-center py-4 px-8 bg-gray-200">
      <div>
        <a href="#">{{ $t('pages.sign_up.privacy_terms') }}</a>
        <span class="mx-4">|</span>
        <a href="#">{{ $t('pages.sign_up.contact_us') }}</a>
      </div>
      <div>
        <a href="#">{{ $t('pages.sign_up.change_region') }}</a>
      </div>
    </footer>
  </div>
</template>
<script>
import { onUnmounted, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useSignUpStore } from '../../../stores/useSignUpStore';

export default {
  setup() {
    const signUpStore = useSignUpStore();
    const router = useRouter();

    onMounted(() => {
      if (signUpStore.isformSubmitted === false) {
        router.push('/sign_up');
      }
    });

    onUnmounted(() => {
      signUpStore.isformSubmitted = false;
    });
    return { signUpStore };
  },
};
</script>
<style scoped></style>
