<template>
  <div
    :class="{ 'bg-secondary': isChatOpen }"
    class="flex rounded-md items-center hover-trigger-x justify-between pl-2 py-1 hover:bg-primaryHover cursor-pointer duration-200"
    @click="goTo(`/groups/${group.id}`, group)"
  >
    <span class="flex item-center w-full">
      <n-avatar :size="25" :src="membersProfileImage" />
      <div class="flex z-10 items-end">
        <div
          class="bg-black-700 flex items-center justify-center awayStatus text-black-800 inactivePosition h-3 w-3 border rounded"
        >
          <span class="text-black-400 font-bold text_size">
            {{ getMembersCount }}</span
          >
        </div>
      </div>
      <p
        class="ml-2 text-sm truncate"
        :class="isChatOpen ? 'text-white' : 'text-black-400'"
      >
        {{ group.name }}
      </p>
    </span>
  </div>
</template>

<script>
import { NAvatar } from 'naive-ui';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';
export default {
  components: { NAvatar },
  props: ['group', 'goTo'],
  setup() {
    const profileStore = useProfileStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { profileStore, selectedChat };
  },
  computed: {
    membersProfileImage() {
      return this.group.profiles
        ? this.group.profiles[0].image_url
        : this.profileStore.getProfileById(this.group.profile_ids[0]).image_url;
    },
    getMembersCount() {
      return this.group.profiles
        ? this.group.profiles.length
        : this.group.profile_ids.length;
    },
    isChatOpen() {
      return (
        this.selectedChat.id === this.group.id &&
        this.selectedChat.conversation_type === this.group.conversation_type
      );
    },
  },
};
</script>

<style scoped>
.text_size {
  font-size: 10px;
  font-weight: bold;
}
</style>
