<template>
  <div class="relative">
    <div class="custom-border px-1 h-12 items-center flex justify-between">
      <div class="flex px-1 my-2 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer">
        <n-avatar class="mr-1" size="small" :src="chat.avatar" />
        <span v-if="chat.isActive" class="bg-success rounded-full border-primary border-2 h-3 w-3 relative -ml-3 mt-4 " />
        <p class="text-xl self-center font-semibold pl-1">{{ chat.name }}</p>
        <i
          v-if="chat.status == 'wfh'"
          class="fa-solid fa-house-laptop self-center fa-lg mr-1"
        />
        <i class="fa-solid fa-chevron-down self-center fa-xs ml-1" />
      </div>
      <div class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer">
        <i class="fa-solid fa-phone self-center "/>
      </div>
    </div>
  </div>
</template>

<script>
import { NAvatar, NIcon } from 'naive-ui';

export default {
  name: 'UserChatInfo',
  components: { NAvatar, NIcon },
  props: ['chat'],
};
</script>

<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
