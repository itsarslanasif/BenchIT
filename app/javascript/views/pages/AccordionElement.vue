<template>
  <AccordionList>
    <AccordionItem>
      <h3>H1</h3>
      <h3>Main content</h3>
    </AccordionItem>
  </AccordionList>
  </template>


  <script>
      import { useAccordion } from "vue3-rich-accordion";
      import { AccordionList, AccordionItem } from "vue3-rich-accordion";
      export default {
    components: { useAccordion,AccordionList,AccordionItem }
  }
  </script>


  <style>
  </style>
