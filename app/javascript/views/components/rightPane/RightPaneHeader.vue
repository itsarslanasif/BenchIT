<template>
  <div class="relative">
    <div class="custom-border h-12 px-1 items-center flex justify-between">
      <div
        @click="messageId ? goToMessage : null"
        class="flex px-1 ml-2 my-2 overflow-x-hidden text-ellipsis rounded" :class="{'hover:bg-transparent cursor-pointer' : messageId}"
        >
        <p class="text-lg font-semibold self-center mr-2"> {{messageId ? $t('right_pane.thread') : $t('right_pane.profile') }}</p>
        <p v-if="messageId" class="text-md text-black-600 self-center mr-1">{{ paneTitle }}</p>
      </div>
      <div
        @click="messageId ? rightPaneStore?.toggleThreadShow(false) : closeProfilePane()"
        class="flex items-center justify-center mr-2 w-8 h-8 rounded hover:bg-transparent cursor-pointer"
      >
        <i class="fas fa-xmark self-center fa-lg"></i>
      </div>
    </div>
  </div>
</template>

<script>
import { useThreadStore } from '../../../stores/useThreadStore';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';

export default {
  name: 'RightPaneHeader',
  props: ['paneTitle', 'messageId'],
  methods: {
    goToMessage() {
      this.$router.push(this.messageId);
    },
    closeProfilePane() {
      this.rightPaneStore?.toggleUserProfileShow(false)
      this.userProfileStore.setUserProfile({})
    },
  },
  setup() {
    const threadStore = useThreadStore();
    const userProfileStore = useUserProfileStore();
    const rightPaneStore = useRightPaneStore();
    return {threadStore, userProfileStore, rightPaneStore};
  },
};
</script>
<style scoped>
.custom-border {
  border-bottom: 0.5px solid gray;
}
</style>
