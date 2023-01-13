<template>
  <div class="hover-trigger">
    <font-awesome-icon
      @click="goToNewDMList"
      icon="fa-plus"
      class="hover-target p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
    />
    <AccordionList class="mt-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer">
            {{ $t('direct_messages.direct_messages') }}
          </span>
        </template>
        <directMessagesItemVue
          :sortedDMList="sortedDMList"
          :isOwnChat="isOwnChat"
          :goToChat="goToChat"
        />
      </AccordionItem>
    </AccordionList>
    <div class="px-3 hover:bg-primaryHover cursor-pointer" @click="closeModal">
      <addTeammatesDropdown :items="options" />
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
