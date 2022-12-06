<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>{{ $t('direct_messages.direct_messages') }}</template>
        <h5 v-for="user in dmList" :key="user.id" class="hover:bg-primaryHover">
          <div @click="goToChat(`/users/${user.id}`)"
            class="-ml-3 pl-3 flex items-start py-1 cursor-pointer hover:bg-primaryHover">
            <img class="w-5 h-5 rounded-md"
              src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg" />
            <p class="ml-3 text-xs  text-white">{{ user.name }}</p>
          </div>
        </h5>
        <div class="-ml-3 flex items-start py-1 hover:bg-primaryHover" @click="modalOpen = !modalOpen">
          <addTeammatesDropdown :items="options"></addTeammatesDropdown>
        </div>
      </AccordionItem>
    </AccordionList>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import addTeammatesDropdown from '../../widgets/addTeammatesDropdown.vue';
import { getDirectMessagesList } from '../../../api/directMessages/directMessages';
export default {
  components: { AccordionList, AccordionItem, addTeammatesDropdown },
  data() {
    return {
      dmList: [],
      modalOpen: false,
      options: [
        {
          title: 'Invite people',
          link: '#',
        },
        {
          title: 'New Conversation',
          link: '#',
        },
      ],
    };
  },
  mounted() {
    this.getDmList();
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    async getDmList() {
      this.dmList = await getDirectMessagesList('1');
    },
    goToChat(chatURL) {
      window.location.href = chatURL;
    },
  },
};
</script>
