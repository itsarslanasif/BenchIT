<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>Direct Messages</template>
        <h5
          v-for="directMessage in dms"
          :key="directMessage"
          class="hover:bg-primaryHover"
        >
          <router-link :to="`/channel/${asad}`">
            <div class="-ml-3 pl-3 flex items-start py-1 hover:bg-primaryHover">
              <img
                class="w-5 h-5 rounded-md"
                src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
              />
              <p class="ml-3 text-white">{{ directMessage }}</p>
            </div>
          </router-link>
        </h5>
        <div
          class="-ml-3 flex items-start py-1 hover:bg-primaryHover"
          @click="modalOpen = !modalOpen"
        >
          <addMemberDropDown title="Add Teammates" :items="options" ></addMemberDropDown>
        </div>
      </AccordionItem>
    </AccordionList>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import { CONSTANTS } from '../../../assets/constants';
import addMemberDropDown from '../../widgets/addMemberDropDown.vue'

export default {
  components: { AccordionList, AccordionItem ,addMemberDropDown,},

  data() {
    return {
      dms: ['asad', 'ali', 'alina'],
      CONSTANTS: CONSTANTS,
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
  methods: {
    closeModal() {
      console.log(this.dms);
      this.modalOpen = !this.modalOpen;
    },
  },
};
</script>
