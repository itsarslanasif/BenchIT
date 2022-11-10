<template>
  <div class="container">
    <div class="workplace">
      <strong>Devsinc</strong>
    </div>

    <hr />

    <div class="main">
      <IconElement icon="&#8860;" space="&nbsp;" name="Threads" />
      <IconElement icon="&#8704;" space="&nbsp;" name="Direct messages" />
      <IconElement icon="&#64;" space="&nbsp;" name="Mentions & reactions" />
      <IconElement icon="&#8634;" space="&nbsp;" name="Draft & sent" />
      <IconElement icon="&#8285;" space="&nbsp; &nbsp;" name="More" />
      <p>&#8860; &nbsp; Threads</p>
      <p>&#8704; &nbsp; Direct messages</p>
      <p>&#64; &nbsp;Mentions & reactions</p>
      <p>&#8634; &nbsp; Draft & sent</p>
      <p>&#8285; &nbsp; &nbsp; More</p>
    </div>

    <hr />

    <div>
      <Accordion />
      <Accordion />
    </div>

    <div class="bottom_div">
      <hr />
      <p>selected channel</p>
    </div>
  </div>
</template>

<script>
import Accordion from './Accordion.vue';
import IconElement from './IconElement.vue';

export default {
  components: { Accordion, IconElement },
};
</script>

<style>
.container {
  background-color: #3f0e40;
}

.workplace {
  height: 20px;
  margin-top: 22px;
}

.bottom_div {
  margin-top: 50vh;
  height: 40px;
}

p,
strong {
  font-family: sans-serif;
  margin-left: 10px;
}

hr {
  height: 1px;
  background-color: rgb(86, 48, 89);
  border: none;
}
</style>
