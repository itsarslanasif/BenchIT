<template>
  <div class="hover-trigger">
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer">
            {{ $t('direct_messages.direct_messages') }}
          </span>
          <font-awesome-icon
            @click="handleClick"
            icon="fa-plus"
            class="hover-target px-2 p-2 float-right -ml-12 mr-4 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
          />
        </template>
        {{ directMessages }}
        <directMessagesItemVue
          :sortedDMList="sortedDMList"
          :isOwnChat="isOwnChat"
          :goToChat="goToChat"
        />
      </AccordionItem>
      <div
        class="-ml-3 flex items-start py-1 hover:bg-primaryHover"
        @click="closeModal"
      >
        <addTeammatesDropdown :items="options" />
      </div>
    </AccordionList>
  </div>
</template>

<script>
import directMessagesItemVue from './directMessagesItem.vue';
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import addTeammatesDropdown from '../../widgets/addTeammatesDropdown.vue';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore';
import { CONSTANTS } from '../../../assets/constants';
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
    const messagesStore = useMessageStore();
    return { directMessageStore, currentProfileStore, messagesStore };
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
    },
    handleClick() {
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
