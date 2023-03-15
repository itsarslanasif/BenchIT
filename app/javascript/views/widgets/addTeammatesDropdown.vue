<template>
  <div class="cursor-pointer" @click="toggleModal">
    <div class="px-2 flex hover:bg-primaryHover cursor-pointer py-1">
      <font-awesome-icon
        icon="fa-plus"
        class="self-center mr-2 text-xs cursor-pointer text-black-400 rounded-md p-2 bg-secondary"
      />
      <p class="text-sm self-center text-black-400 truncate">
        {{ $t('direct_messages.add_teammates') }}
      </p>
    </div>

    <transition v-click-outside="toggleModal" name="fade" appear>
      <div
        class="bg-white rounded text-black-800 opacity-100 fixed text-sm z-10 ml-10"
        v-if="isOpen"
      >
        <div class="py-2">
          <div
            v-for="option in options"
            :key="option.key"
            class="hover:bg-primaryHover hover:text-white"
            @click="handleSelect(option.key)"
          >
            <div class="px-4">
              {{ option.label }}
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
  <UserInviteModal v-model:show="showInviteModal" />
</template>

<script>
import vClickOutside from 'click-outside-vue3';
import UserInviteModal from './userInviteModal.vue';
import { CONSTANTS } from '../../assets/constants.js';

export default {
  components: { UserInviteModal },
  name: 'dropdown',
  directives: {
    clickOutside: vClickOutside.directive,
  },
  data() {
    return {
      isOpen: false,
      UserInviteFormFlag: false,
      showInviteModal: false,
      options: [
        {
          label: CONSTANTS.INVITE_PEOPLE,
          key: this.generateKey(CONSTANTS.INVITE_PEOPLE),
        },
        {
          label: CONSTANTS.NEW_CONVERSATION,
          key: this.generateKey(CONSTANTS.NEW_CONVERSATION),
        },
      ],
    };
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'invite-people':
          this.showInviteModal = true;
          break;
        case 'new-conversation':
          this.$router.push('/direct_messages');
        break;
      }
    },
    toggleModal() {
      this.isOpen = !this.isOpen;
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
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
