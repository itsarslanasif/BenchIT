<template>
  <AccordionList>
    <AccordionItem>
      <h5 v-for="channel in this.channels" v-bind:key="user">
        <router-link :to="`/screen/${channel.name}`"># {{channel.name}} </router-link>
      </h5>
    </AccordionItem>
  </AccordionList>
  </template>


  <script>
      import axios from "axios";
      import { useAccordion } from "vue3-rich-accordion";
      import { AccordionList, AccordionItem } from "vue3-rich-accordion";
      export default {
    components: { useAccordion,AccordionList,AccordionItem },

    data()
    {
      return {
        channels:[]
      }
    },
    async mounted()
    {
      let result = axios.get("https://mocki.io/v1/f4eff2a8-537f-4feb-9095-265e27a28085");
      this.channels=((await result).data);
    }
  }
  </script>


  <style>
  </style>
