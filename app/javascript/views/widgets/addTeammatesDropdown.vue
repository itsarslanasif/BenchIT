<template>
  <div class="cursor-pointer" @click="toggleModal">
    <div class="px-2 flex hover:bg-primaryHover cursor-pointer py-1">
      <font-awesome-icon
        icon="fa-plus"
        class="self-center mr-2 text-xs cursor-pointer text-white rounded-md p-2 bg-slate-600"
      />
      <p class="text-sm self-center text-white">
        {{ $t('direct_messages.add_teammates') }}
      </p>
    </div>

    <transition v-click-outside="toggleModel" name="fade" appear>
      <div
        class="bg-white rounded text-black-800 opacity-100 fixed text-sm z-10 ml-10"
        v-if="isOpen"
      >
        <div class="py-2">
          <div
            v-for="item in items"
            :key="item"
            class="hover:bg-primaryHover hover:text-white"
            @click="item.func"
          >
            <div class="px-4">
              {{ item.title }}
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import vClickOutside from 'click-outside-vue3';
export default {
  name: 'dropdown',
  props: ['title', 'items'],
  directives: {
    clickOutside: vClickOutside.directive,
  },
  data() {
    return {
      isOpen: false,
      UserInviteFormFlag: false,
    };
  },
  methods: {
    toggleModel() {
      this.isOpen = !this.isOpen;
    },
    displayItem(e) {
      switch (e.target.outerText) {
        case 'Invite People':
          this.UserInviteFormFlag = true;
          break;
      }
    },
    toggleModal() {
      this.isOpen = !this.isOpen;
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
