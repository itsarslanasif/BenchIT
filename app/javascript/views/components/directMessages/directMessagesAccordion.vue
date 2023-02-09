<template>
  <div class="hover-trigger">
    <font-awesome-icon
      @click="goToDirectMessages"
      icon="fa-plus"
      class="hover-target p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
    />
    <AccordionList
      class="mt-5 ml-4 text-base text-slate-50"
      @click="toggleList"
    >
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer truncate">
            {{ $t('direct_messages.direct_messages') }}
          </span>
        </template>
        <div class="-ml-4">
          <div v-if="sortedDMList">
            <h5
              v-for="user in sortedDMList"
              :key="user"
              class="hover:bg-primaryHover"
              @click.stop="stopPropagation"
            >
              <directMessagesItemVue
                :user="user"
                :isOwnChat="isOwnChat"
                :goToChat="goToChat"
              />
            </h5>
          </div>
          <div
            class="hover:bg-primaryHover cursor-pointer"
            @click="closeModal"
            @click.stop="stopPropagation"
          >
            <addTeammatesDropdown />
          </div>
        </div>
      </AccordionItem>
    </AccordionList>
    <div v-if="!listOpen && checkSetChat()">
      <h5
        class="hover:bg-primaryHover text-base cursor-pointer text-white bg-slate-600"
      >
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
import { CONSTANTS } from '../../../assets/constants';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';
import { useRightpaneMessageStore } from '../../../stores/useRightpaneMessageStore'
import { useRightPaneStore } from '../../../stores/useRightPaneStore'

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
    const rightPaneMessageStore = useRightpaneMessageStore();
    const rightPaneStore = useRightPaneStore();
    return {
      directMessageStore,
      currentProfileStore,
      messagesStore,
      leftPaneStore,
      selectedChat,
      rightPaneMessageStore,
      rightPaneStore
    };
  },
  computed: {
    sortedDMList() {
      return this.directMessageStore.getSortedDMList(
        this.currentProfileStore.currentProfile.id
      );
    },
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    goToChat(chatURL, user, event) {
      if (event.ctrlKey || event.metaKey) {
        this.rightPaneMessageStore.setSelectedChat(user);
        this.rightPaneStore.toggleChatShow(true);
      } else {
        this.messagesStore.setSelectedChat(user);
        this.$router.push(chatURL);
        if (this.isMobileView()) {
          this.leftPaneStore.closeLeftPane();
        }
        this.setType();
      }
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
    checkSetChat() {
      return (
        this.chat_type === 'Profile' &&
        this.selectedUser.id === this.selectedChat.id
      );
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
