<template>
  <AccordionList>
    <AccordionItem>
      <h5 v-for="channel in this.channels" v-bind:key="channel">
        <router-link :to="`/channel/${channel.name}`"># {{ channel.name }} </router-link>
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
