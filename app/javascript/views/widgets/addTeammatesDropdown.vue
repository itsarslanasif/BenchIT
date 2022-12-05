<template>
  <div class="flex py-2" @click="isOpen = !isOpen">
    <div class="text-white  text-xl hover:bg-primaryHover flex">
      <p
        class="w-5 h-5 ml-3 text-xs cursor-pointer  text-center text-white rounded-md hover:bg-slate-800 border-slate-200 border border-solid"
      >
        +
      </p>
      <p class="ml-3 text-xs text-white">{{ $t('direct_messages.add_teammates') }}</p>
    </div>

    <transition name="fade" appear>
      <div
        class="bg-white rounded-md text-black-900 opacity-100 fixed z-10 p-3 ml-10 -mt-1"
        v-if="isOpen"
      >
        <div
          v-for="item in items"
          :key="item"
          class="p-4 hover:bg-primaryHover hover:text-white rounded-md"
          @click="item.func"
        >
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
      }
    },
  },
};
</script>

<style>
.menu-item {
  width: 100px;
}

.icon-style {
  padding: 1px;
}

.menu-item {
  height: 55px;
}

.sub-menu {
  background-color: white;
  border-radius: 100px;
  color: black;
  height: 100px;
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
