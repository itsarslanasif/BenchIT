<template>
  <div class="h-full w-full bg-white flex flex-col items-center">
    <div class="grid grid-cols-4 items-center w-full p-3 h-[184px]">
      <div></div>
      <div class="center-col col-span-2 justify-self-center">
        <a href="http://127.0.0.1:5100/"
          ><img class="w-25 h-40" src="../../../assets/images/Bench IT.png"
        /></a>
      </div>
      <div v-if="isSignUpPage" class="right-col text-md">
        <p>
          {{ $t('pages.sign_up.instructions1') }}<br />
          <a class="text-woot-800" href="http://127.0.0.1:5100/sign_in">{{
            $t('pages.sign_up.sign_in_instead')
          }}</a>
        </p>
      </div>
    </div>
  </div>
  <div class="sign-up flex flex-col">
    <router-view></router-view>
  </div>
</template>
<script>
import { onMounted, onUnmounted, computed } from 'vue';
import { RouterView, useRoute } from 'vue-router';

export default {
  setup() {
    const route = useRoute();

    const isSignUpPage = computed(() => {
      return route.path === '/sign_up';
    });

    onMounted(() => {
      window.addEventListener('resize', handleResize);
      handleResize();
    });

    onUnmounted(() => {
      window.removeEventListener('resize', handleResize);
    });

    const handleResize = () => {
      const height = window.innerHeight - 184;
      const signup = document.getElementsByClassName('sign-up');
      signup[0].style.height = `${height}px`;
    };

    return {
      isSignUpPage,
    };
  },
};
</script>
