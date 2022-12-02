<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>{{ $t('channels.channels') }}</template>
        <h5
          v-for="channel in channels"
          :key="channel.id"
          class="hover:bg-primaryHover"
        >
          <div
            @click="goToChannelChat(`/channels/${channel.id}`)"
            class="-ml-3 pl-3 hover:bg-primaryHover"
          >
            <i class="fa fa-hashtag mr-2 font-bold">#</i>{{ channel.name }}
          </div>
        </h5>
        <div
          class="mt-2 -ml-3 hover:bg-primaryHover"
          @click="modalOpen = !modalOpen"
        >
          <h5 class="pl-3">{{ $t('channels.add_new_channel') }}</h5>
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
import CreateChannel from '../../containers/CreateChannel.vue';

export default {
  components: { AccordionList, AccordionItem, CreateChannel },

  data() {
    return {
      channels: [],
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
    goToChannelChat(chatURL) {
      window.location.href = chatURL;
    },
  },
};
</script>
