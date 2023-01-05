<template>
  <div class="hover-trigger">
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>
          {{ $t('direct_messages.direct_messages') }}
          <a
            @click="handleClick"
            class="px-2 hover-target py-1 h-5 ml-10 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-800 border-slate-200 border border-solid"
          >
            +
          </a>
        </template>
        <h5
          v-for="user in directMessageStore.directMessagesList"
          :key="user.id"
          class="hover:bg-primaryHover"
        >
          <div
            @click="goToChat(`/profiles/${user.id}`, user)"
            class="flex items-center -ml-3 pl-3 py-1 cursor-pointer hover:bg-primaryHover"
          >
            <img class="w-6 h-6 rounded-md" :src="user.image_url" />
            <p class="ml-2 text-sm text-white">{{ user.username }}</p>
          </div>
        </h5>
        <div
          class="-ml-3 flex items-start py-1 hover:bg-primaryHover"
          @click="closeModal"
        >
          <addTeammatesDropdown :items="options" />
        </div>
      </AccordionItem>
    </AccordionList>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import addTeammatesDropdown from '../../widgets/addTeammatesDropdown.vue';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore';
import { CONSTANTS } from '../../../assets/constants';

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
      this.currentProfileStore.currentProfile.workspace_id
    );
  },
  beforeUnmount() {
    this.options = null;
  },
  setup() {
    const directMessageStore = useDirectMessagesStore();
    const currentProfileStore = useCurrentProfileStore();
    return { directMessageStore, currentProfileStore };
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    goToChat(chatURL, user) {
      this.directMessageStore.setSelectedDm(user);
      this.$router.push(chatURL);
    },
    handleClick() {
      this.$router.push('/new_direct_message');
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
