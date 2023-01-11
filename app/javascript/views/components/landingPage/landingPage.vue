<template>
  <div
    v-if="!leftPaneStore.getLeftpaneFlag"
    @click="leftPaneStore.openLeftPane"
    class="text-2xl m-2"
  >
    <font-awesome-icon
      icon="fa-newspaper"
      class="hover:bg-slate-50 rounded cursor-pointer p-3"
    />
  </div>
  <div
    class="h-screen -mb-12 text-center flex flex-col justify-center items-center"
  >
    <div class="text-5xl -mt-10">
      <font-awesome-icon icon="fa-message" />
    </div>
    <div class="text-2xl">
      {{ $t('welcome.no_chat_selected') }}
    </div>
    <div>
      {{ $t('welcome.tagline') }}
    </div>
  </div>
</template>
<script>
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
export default {
  setup() {
    const leftPaneStore = useLeftpaneStore();
    return {
      leftPaneStore,
    };
  },
};
</script>
