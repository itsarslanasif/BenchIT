<template>
  <div class="menu-item" @click="isOpen = !isOpen">
    <div class="main-bar">
      <a href="#">
        {{ title }}
      </a>
      <svg class="icon-style" viewBox="0 0 1060 638" width="10">
        <path
          d="M1017 68L541 626q-11 12-26 12t-26-12L13 68Q-3 49 6 24.5T39 0h952q24 0 33 24.5t-7 43.5z"
          fill="#FFF"
        ></path>
      </svg>
    </div>

    <transition name="fade" appear>
      <div class="sub-menu" v-if="isOpen">
        <div
          v-for="item in items"
          :key="item"
          class="menu-item"
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

.main-bar {
  color: white;
  border-style: solid;
  display: flex;
  font-size: 25px;
  margin-left: 15px;
  margin-top: 15px;
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
