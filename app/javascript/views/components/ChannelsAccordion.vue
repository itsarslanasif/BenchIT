<template>
  <AccordionList class="mt-4">
    <AccordionItem default-opened="true">
      <template #summary>Channels</template>
      <h5 class="ml-3 text-slate-100" v-for="channel in this.channels" v-bind:key="channel">
        <router-link :to="`/channel/${channel.name}`">
          <i class="fa fa-hashtag mr-3">#</i>{{ channel.name }}

        </router-link>
      </h5>
    </AccordionItem>
  </AccordionList>
</template>


<script>
import { getChannels } from '../../api/channels/channelsapi.js'
import { useAccordion } from "vue3-rich-accordion";
import { AccordionList, AccordionItem } from "vue3-rich-accordion";

export default {
  components: { useAccordion, AccordionList, AccordionItem },

  data() {
    return {
      channels: []
    }
  },
  async mounted() {
    this.channels = await getChannels();
  }
}
</script>
