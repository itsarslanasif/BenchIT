<template>
  <div class="hover-trigger mx-2">
    <font-awesome-icon
      @click="goToDirectMessages"
      icon="fa-plus"
      class="hover-target p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-black-400 hover:bg-primaryHover rounded-md"
    />
    <AccordionList class="mt-4 ml-4 text-sm text-black-400" @click="toggleList">
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-1 cursor-pointer font-semibold truncate">
            {{ $t('direct_messages.direct_messages') }}
          </span>
        </template>
        <div class="-ml-4">
          <div v-if="sortedDMList">
            <h5
              v-for="user in sortedDMList"
              :key="user"
              @click.stop="stopPropagation"
            >
              <directMessagesItemVue
                :user="user"
                :isOwnChat="isOwnChat"
                :goToChat="goToChat"
              />
            </h5>
          </div>
          <div @click="closeModal" @click.stop="stopPropagation">
            <addTeammatesDropdown />
          </div>
        </div>
      </AccordionItem>
    </AccordionList>
    <div v-if="!listOpen && checkSetChat">
      <h5 class="text-base text-white cursor-pointer">
        <directMessagesItemVue
          :user="this.selectedUser"
          :isOwnChat="isOwnChat"
          :goToChat="goToChat"
        />
      </h5>
    </div>
  </div>
</template>

<script>
import directMessagesItemVue from './directMessagesItem.vue';
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import addTeammatesDropdown from '../../widgets/addTeammatesDropdown.vue';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';

export default {
  components: {
    AccordionList,
    AccordionItem,
    addTeammatesDropdown,
    directMessagesItemVue,
  },
  data() {
    return {
      modalOpen: false,
      listOpen: true,
      selectedUser: {},
      chat_type: '',
    };
  },
  async mounted() {
    await this.directMessageStore.getDmList(
      this.currentProfileStore.currentProfile?.workspace_id
    );
    this.dmList = this.directMessageStore.getDirectMessages;
  },

  setup() {
    const directMessageStore = useDirectMessagesStore();
    const currentProfileStore = useCurrentProfileStore();
    const leftPaneStore = useLeftpaneStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return {
      directMessageStore,
      currentProfileStore,
      messagesStore,
      leftPaneStore,
      selectedChat,
    };
  },
  computed: {
    sortedDMList() {
      return this.directMessageStore.getSortedDMList(
        this.currentProfileStore.currentProfile.id
      );
    },
    checkSetChat() {
      return (
        this.chat_type === 'Profile' &&
        this.selectedUser.id === this.selectedChat.id
      );
    },
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    goToChat(chatURL, user) {
      this.messagesStore.setSelectedChat(user);
      this.$router.push(chatURL);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
      this.setType();
    },
    isMobileView() {
      return window.innerWidth < 1400;
    },
    goToDirectMessages() {
      this.$router.push('/direct_messages');
    },
    isOwnChat(user) {
      return this.currentProfileStore.currentProfile?.id === user?.id;
    },
    toggleList() {
      this.listOpen = !this.listOpen;
      this.setType();
    },
    setType() {
      this.chat_type = this.selectedChat.conversation_type;
      if (this.chat_type === 'Profile') {
        this.selectedUser = this.selectedChat;
      }
    },
  },
};
</script>

<style scoped>
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
