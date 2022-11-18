<template>
  <div class='container text-lg'>
    <hr>
    <div class='workplace'>
      <b>Devsinc</b>
    </div>
    <hr>
    <div class='menu mt-4 mb-4 ml-2 '>
      <IconElement icon='&#8860;' space='&nbsp;' name='Threads' />
      <IconElement icon='&#8704;' space='&nbsp;' name='Direct messages' />
      <IconElement icon='&#64;' space='&nbsp;' name='Mentions & reactions' />
      <IconElement icon='&#8634;' space='&nbsp;' name='Draft & sent' />
      <IconElement icon='&#8285;' space='&nbsp; &nbsp;' name='More' />
    </div>
    <hr>
    <div>
      <p><ChannelsAccordion /></p>
      <p><ChannelsAccordion /></p>
    </div>
    <div class='bottom_div'>
    <hr>
    <p>selected channel</p>
   </div>
  </div>
</template>

<script>
  import ChannelsAccordion from './ChannelsAccordion.vue';
  import IconElement from './IconElement.vue';

  export default {
   components: { ChannelsAccordion, IconElement },
 }
</script>

<style scoped>
.container {
  background-color: #3f0e40;
}

.workplace {
  height: 30px;
  margin-top: 22px;
}

.menu {
  position: relative;
}

.bottom_div {
  bottom: 15px;
  position: absolute;
}

p,b {
  font-family: sans-serif;
  color: white;
}

p {
  margin-left: 10px;
}

b {
  margin-left: 12px;
}

hr {
  height: 1px;
  background-color: rgb(86, 48, 89);
  border: none;
}
</style>
