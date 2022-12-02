<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>{{ $t(CONSTANTS.CHANNELS) }}</template>
        <h5 v-for="channel in channels" :key="channel" class="hover:bg-primaryHover">
          <router-link :to="`/channel/${channel.name}`">
            <div class="-ml-3 pl-3 hover:bg-primaryHover">
              <i class="fa fa-hashtag mr-2 font-bold">#</i>{{ channel.name }}
            </div>
          </router-link>
        </h5>
        <div class="mt-2 -ml-3 hover:bg-primaryHover" @click="modalOpen = !modalOpen">
          <h5 class="pl-3">{{ $t(CONSTANTS.ADD_NEW_CHANNEL) }}</h5>
        </div>
      </AccordionItem>
    </AccordionList>
    <div v-if="modalOpen">
      <CreateChannel :close-modal="closeModal" />
    </div>
  </div>
</template>

<script>
import { getChannels } from '../../../api/channels/channels.js';
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import { CONSTANTS } from '../../../assets/constants';
import CreateChannel from '../../containers/CreateChannel.vue';

export default {
  components: { AccordionList, AccordionItem, CreateChannel },

  data() {
    return {
      channels: [],
      CONSTANTS: CONSTANTS,
      modalOpen: false,
    };
  },
  async mounted() {
    this.channels = await getChannels();
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
  },
};
</script>
