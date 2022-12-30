<template>
  <div class="flex py-2 w-full" @click="openModal">
    <div class="text-white text-xl hover:bg-primaryHover flex">
      <p
        class="w-6 h-6 ml-3 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-800 border-slate-200 border border-solid">
        +
      </p>
      <p class="ml-3 text-xs text-white">{{ $t('direct_messages.add_teammates') }}</p>
    </div>

    <transition name="fade" appear>
      <div class="bg-white rounded text-black-800 opacity-100 fixed text-sm z-10 ml-10" v-if="isOpen">
        <div class="py-2">
          <div v-for="item in items" :key="item" class="hover:bg-primaryHover hover:text-white" @click="item.func">
            <div class="px-4 py-1 ">
              {{ item.title }}
            </div>
          </div>
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
    openModal() {
      this.isOpen = !this.isOpen;
    }
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
