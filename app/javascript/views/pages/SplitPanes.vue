<template>
  <splitpanes class="default-theme">

   <pane max-size="33" min-size="10.45" style="background-color:#3f0e40;" ></pane>

   <pane max-size="100" min-size="67">
<div class="editor">
  <editor
	api-key="v69g5pnxcpt0m2kmjntucft1sek0y2g7qw17n2scwu0pi76w"
  :init="{
      menubar: false,
      plugins: 'lists link image emoticons',
      toolbar: 'styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist | link image emoticons'
    }"
  />
</div>
   </pane>

  </splitpanes>
 </template>

 <script>

 import { Splitpanes, Pane } from 'splitpanes'
 import 'splitpanes/dist/splitpanes.css'
 import Editor from "@tinymce/tinymce-vue";
 export default {
   components: {
    Splitpanes,
    Pane,
    editor: Editor }
 }
 </script>

 <style>
 splitpanes{
 height: 100vh;
 }

 .editor {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 75vh;
}
 </style>


