<template>
  <div class="flex p-2 pl-4" @click="isOpen = !isOpen">
    <div class="text-white text-xl flex">
      <div class="mr-1">
        <strong>{{ title }}</strong>
      </div>
      <svg class="icon-style" viewBox="0 0 1060 638" width="10">
        <path d="M1017 68L541 626q-11 12-26 12t-26-12L13 68Q-3 49 6 24.5T39 0h952q24 0 33 24.5t-7 43.5z" fill="#FFF">
        </path>
      </svg>
    </div>

    <transition name="fade" appear>
      <div class="bg-white rounded-md text-black-900 opacity-100 fixed z-10 p-3 ml-10 -mt-1" v-if="isOpen">
        <div v-for="item in items" :key="item" class="p-4 hover:bg-primaryHover hover:text-white rounded-md"
          @click="item.func">
          {{ item.title }}
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'dropdown',
  props: ['title', 'items'],
  data() {
    return {
      isOpen: false,
      UserInviteFormFlag: false,
    };
  },
  methods: {
    displayItem(e) {
      switch (e.target.outerText) {
        case 'Invite People':
          this.UserInviteFormFlag = true;
          break;
        default:
          break;
      }
    },
  },
};
</script>

<style>
.menu-item {
  width: 300px;
}

.icon-style {
  padding: 1px;
}

.menu-item {
  height: 55px;
}

.sub-menu {
  background-color: white;
  border-radius: 10px;
  color: black;
  height: 500px;
  margin-left: 10px;
  opacity: 1;
  padding-left: 10px;
  padding-top: 10px;
  position: fixed;
  width: 300px;
  z-index: 1;
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s ease-out;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
