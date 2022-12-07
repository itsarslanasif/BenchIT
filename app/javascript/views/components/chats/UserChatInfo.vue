<template>
  <div class="p-1 relative">
    <div class="header">
      <div class="headerContainer hover:bg-transparent rounded cursor-pointer">
        <n-avatar class="mr-1" size="small" :src="chat.avatar" />
        <span v-if="chat.isActive" class="avatar__badge" />
        <p class="name pl-1">{{ chat.name }}</p>
        <i
          v-if="chat.status == 'wfh'"
          class="fa-solid fa-house-laptop self-center fa-lg mr-1"
        ></i>
        <i class="fa-solid fa-chevron-down self-center fa-lg ml-1"></i>
      </div>
      <div
        class="
          flex
          items-center
          justify-center
          mr-2
          w-8
          h-8
          rounded
          hover:bg-transparent
          cursor-pointer
        "
      >
        <i class="fa-solid fa-phone self-center fa-lg"></i>
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
.headerContainer {
  display: flex;
  overflow-y: hidden;
  text-overflow: ellipsis;
  scrollbar-color: dark;
  padding: 5px;
}

.header {
  align-items: center;
  border-bottom: 0.5px solid gray;
  display: flex;
  height: fit-content;
  justify-content: space-between;
  padding: 5px;
}

.phone-btn {
  align-items: center;
  border-radius: 3px;
  display: flex;
  height: 30px;
  justify-content: center;
  margin: 0px 10px 0px 10px;
  width: 30px;
}

.phone-btn:hover {
  background-color: rgb(230, 232, 234);
  cursor: pointer;
}

.avatar__badge {
  background-color: rgb(54, 151, 54);
  border-radius: 50%;
  border: 2px solid white;
  height: 12px;
  margin-left: -12px;
  margin-top: 18px;
  position: relative;
  width: 12px;
}

.name {
  color: rgb(52, 51, 51);
  font-size: 20px;
  font-weight: 600;
}
</style>
