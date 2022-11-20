<template>
  <div class="menu-item" @click="isOpen = !isOpen">
    <div class="main-bar">
    <a  href="#">
      {{ title }}
    </a>
    <svg class="icon-style" viewBox="0 0 1060 638" width="10">
      <path d="M1017 68L541 626q-11 12-26 12t-26-12L13 68Q-3 49 6 24.5T39 0h952q24 0 33 24.5t-7 43.5z" fill="#FFF"></path>
    </svg>
    </div>

    <transition name="fade" appear>
      <div class="sub-menu" v-if="isOpen">
        <div v-for="(item, i) in items" :key="i" class="menu-item">
          <a :href="item.link">{{ item.title }}</a>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'dropdown',
  props: ['title', 'items'],
  data () {
    return {
      isOpen: false
    }
  }
}
</script>

<style>
 .menu-item{
  width: 300px;
  margin-left: 20px;

}
.icon-style{
  margin-left:40%;
}
.menu-item{
  height: 55px;

}
.main-bar{
  font-size: 30px;
  display: flex;
}

.sub-menu {
  background-color: white;
  color: black;
  width: 350px;
  height:500px;
  opacity: 1;

}
.fade-enter-active,
.fade-leave-active {
  transition: all .3s ease-out;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
