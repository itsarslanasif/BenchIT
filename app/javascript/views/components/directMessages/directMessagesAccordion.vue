<template>
  <div class="hover-trigger">
    <font-awesome-icon @click="goToNewDMList" icon="fa-plus"
      class="hover-target p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600" />
    <AccordionList class="mt-5 ml-4 text-base text-slate-50" @click="toggleList">
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer truncate">
            {{ $t('direct_messages.direct_messages') }}
          </span>
        </template>
        <div class="-ml-4">
          <div v-if="sortedDMList">
            <h5 v-for="user in sortedDMList" :key="user" class="hover:bg-primaryHover">
              <directMessagesItemVue :user="user" :isOwnChat="isOwnChat" :goToChat="goToChat" />
            </h5>
          </div>
          <div class="hover:bg-primaryHover cursor-pointer" @click="closeModal">
            <addTeammatesDropdown :items="options" />
          </div>
        </div>
      </AccordionItem>
    </AccordionList>
    <div v-if="!listOpen && this.checkSetChat()">
      <h5 class="hover:bg-primaryHover text-base cursor-pointer text-white bg-slate-600">
        <directMessagesItemVue :user="this.selectedChat" :isOwnChat="isOwnChat" :goToChat="goToChat" />
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
      options: [
        {
          title: CONSTANTS.INVITE_PEOPLE,
          link: '#',
        },
        {
          title: CONSTANTS.NEW_CONVERSATION,
          link: '#',
        },
      ],
      listOpen: true,
      selectedChat: {},
    };
  },
  async mounted() {
    await this.directMessageStore.getDmList(
      this.currentProfileStore.currentProfile?.workspace_id
    );
    this.dmList = this.directMessageStore.getDirectMessages;
  },
  beforeUnmount() {
    this.options = null;
  },
  setup() {
    const directMessageStore = useDirectMessagesStore();
    const currentProfileStore = useCurrentProfileStore();
    const leftPaneStore = useLeftpaneStore();
    const messagesStore = useMessageStore();
    return {
      directMessageStore,
      currentProfileStore,
      messagesStore,
      leftPaneStore,
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
    goToChat(chatURL, user) {
      this.messagesStore.setSelectedChat(user);
      this.$router.push(chatURL);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
      this.messagesStore.selectedChannel = {};
      this.listOpen = this.listOpen ? false : true;
    },
    isMobileView() {
      return window.innerWidth < 1400;
    },
    goToNewDMList() {
      this.$router.push('/new_direct_message');
    },
    isOwnChat(user) {
      return this.currentProfileStore.currentProfile?.id === user?.id;
    },
    toggleList() {
      this.listOpen = !this.listOpen;
      this.selectedChat = this.messagesStore.selectedChat;
    },
    checkSetChat() {
       return this.selectedChat.id === this.messagesStore.selectedChat.id;
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
