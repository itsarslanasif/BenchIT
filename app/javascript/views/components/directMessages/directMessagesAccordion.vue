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
        <h5
          v-for="user in sortedDMList"
          :key="user?.id"
          class="hover:bg-primaryHover"
        >
          <div
            @click="goToChat(`/profiles/${user?.id}`, user)"
            class="flex items-center -ml-4 pl-3 py-1 cursor-pointer hover:bg-primaryHover"
          >
            <img class="w-5 h-5 rounded-md" :src="user?.image_url" />
            <p class="ml-2 text-sm text-white">{{ user?.username }}</p>
            <p v-if="isOwnChat(user)" class="ml-2 text-sm text-black-400">
              {{ $t('pinconversation.you') }}
            </p>
          </div>
        </h5>
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
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import addTeammatesDropdown from '../../widgets/addTeammatesDropdown.vue';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore';
import { CONSTANTS } from '../../../assets/constants';
import { useMessageStore } from '../../../stores/useMessagesStore';

export default {
  components: { AccordionList, AccordionItem, addTeammatesDropdown },
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
  mounted() {
    this.directMessageStore.getDmList(
      this.currentProfileStore.currentProfile?.workspace_id
    );
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
