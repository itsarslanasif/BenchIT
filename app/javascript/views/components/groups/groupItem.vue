<template>
  <div
    class="flex items-center hover-trigger-x justify-between pl-2 py-1 hover:bg-primaryHover cursor-pointer"
  >
    <span class="flex item-center w-full">
      <n-avatar :size="25" :src="group.profiles[0].image_url" />
      <div class="flex z-10 items-end">
        <div
          class="bg-black-700 flex items-center justify-center awayStatus text-black-800 inactivePosition h-3 w-3 border rounded"
        >
          <span class="text-white font-bold text_size">
            {{ group.profiles.length }}</span
          >
        </div>
      </div>
      <p class="ml-2 text-sm text-white truncate">{{ group.name }}</p>
    </span>
  </div>
</template>

<script>
import { NAvatar } from 'naive-ui';
export default {
  components: { NAvatar },
  props: ['group'],
  setup() {
    // const channelStore = useChannelStore();
    // const unreadStore = useUnreadStore();
    // const { unreadMessages } = storeToRefs(unreadStore);
    // return { channelStore, unreadMessages, unreadStore };
  },
  data() {
    return {
      // rightClickMenuOptions: [],
      // currentGroup: {},
      // showRightClickMenu: false,
      // unread: [],
      // unreadDetails: null,
    };
  },
  computed: {
    // unReadMessageExist() {
    //   return this.unreadDetails?.messages.length > 0;
    // },
  },
  methods: {
    // handleSelect(key) {
    //   switch (key) {
    //     case 'star-channel':
    //       markStar(this.currentGroup, this.channelStore);
    //       break;
    //     case 'unstar-channel':
    //       markStar(this.currentGroup, this.channelStore);
    //       break;
    //     case 'mark-as-read':
    //       this.unreadStore.markedChatAsRead('channels', this.channel.id);
    //       break;
    //   }
    // },
    // checkcurrentGroup(channel) {
    //   if (channel.favourite_id) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // },
    // setRightClickMenuOptions() {
    //   this.rightClickMenuOptions = new Option(
    //     this.checkcurrentGroup(this.currentGroup),
    //     this.unReadMessageExist,
    //     true
    //   ).getOptions();
    // },
    // setcurrentGroup() {
    //   this.currentGroup =
    //     this.channelStore.joinedChannels.find(
    //       obj => obj.id === Number(this.channel.id)
    //     ) ||
    //     this.channelStore.starChannels.find(
    //       obj => obj.id === Number(this.channel.id)
    //     );
    //   this.channelStore.setcurrentGroup(this.currentGroup);
    //   this.setRightClickMenuOptions();
    // },
    // toggleRightClickMenu() {
    //   this.showRightClickMenu = !this.showRightClickMenu;
    //   if (this.showRightClickMenu) {
    //     this.setcurrentGroup();
    //   }
    // },
    // isUnreadChannel(channel) {
    //   this.unreadDetails = unreadMessagesCount(
    //     this.unreadMessages,
    //     `BenchChannel${channel?.id}`
    //   );
    //   return this.unreadDetails?.messages.length;
    // },
    // totalUnreadMessages(unreadDetails) {
    //   return unreadMessagesLength(unreadDetails);
    // },
  },
};
</script>

<style scoped>
.text_size {
  font-size: 10px;
  font-weight: bold;
}
</style>
