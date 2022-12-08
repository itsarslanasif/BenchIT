<template>
  <div class="p-1 relative">
    <div class="header items-center flex p-1 justify-between">
      <div class="flex p-1 overflow-x-hidden text-ellipsis hover:bg-transparent rounded cursor-pointer">
        <n-avatar class="mr-1" size="small" :src="chat.avatar" />
        <span v-if="chat.isActive" class="bg-success rounded-full border-primary border-2 h-3 w-3 relative -ml-3 mt-4 " />
        <p class="text-xl self-center text-center font-semibold pl-1">{{ chat.name }}</p>
        <i
          v-if="chat.status == 'wfh'"
          class="fa-solid fa-house-laptop self-center fa-lg mr-1"
        />
        <i class="fa-solid fa-chevron-down self-center fa-lg ml-1" />
      </div>
      <div class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer">
        <i class="fa-solid fa-phone self-center fa-lg"/>
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
.header {
  border-bottom: 0.5px solid gray;
}
</style>
