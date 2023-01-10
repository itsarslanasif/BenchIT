<template>
  <div>
    <h5
      v-for="user in sortedDMList"
      :key="user?.id"
      class="hover:bg-primaryHover"
    >
      <div
        @click="goToChat(`/profiles/${user?.id}`, user)"
        class="flex items-center -ml-4 pl-3 py-1 cursor-pointer hover:bg-primaryHover"
        :class="isUnreadDM(user) ? 'font-bold' : ''"
      >
        <img class="w-5 h-5 rounded-md" :src="user?.image_url" />
        <p class="ml-2 text-sm text-white">{{ user?.username }}</p>
        <p v-if="isOwnChat(user)" class="ml-2 text-sm text-black-400">
          {{ $t('pinconversation.you') }}
        </p>
        <div
          v-if="unreadDetails?.messages.length"
          class="px-2 py-auto rounded-full text-xs bg-successHover ml-auto mr-2"
        >
          {{ unreadDetails.messages.length }}
        </div>
      </div>
    </h5>
  </div>
</template>
<script>
import { useUnreadStore } from '../../../stores/useUnreadStore';
import { storeToRefs } from 'pinia';
import { unreadMessagesCount } from '../../../modules/unreadMessages';
export default {
  props: ['sortedDMList', 'isOwnChat', 'goToChat'],
  data() {
    return {
      unreadMessagesCount: 0,
      unreadDetails: null,
    };
  },
  setup() {
    const unreadStore = useUnreadStore();
    const { unreadMessages } = storeToRefs(unreadStore);
    return {
      unreadMessages,
    };
  },
  methods: {
    isUnreadDM(user) {
      console.log(this.unreadMessages)
      this.unreadDetails = unreadMessagesCount(
        this.unreadMessages,
        `Profile${user?.id}`
      );
      return this.unreadDetails?.messages.length;
    },
  },
  setup() {
    const unreadMessagesStore = useUnreadStore();
    const { unreadMessages } = storeToRefs(unreadMessagesStore);
    return {
      unreadMessages,
    };
  },
};
</script>
