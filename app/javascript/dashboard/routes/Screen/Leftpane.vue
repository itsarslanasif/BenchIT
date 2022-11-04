<template>
  <div class="container">
    <div class="workplace">
      <strong>Devsinc</strong>
    </div>

    <hr />

    <div class="main">
      <Threads />
      <DirectMessags />
      <Mentions />
      <Drafts />
      <More />
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
import Drafts from './Drafts.vue';
import DirectMessags from './DirectMessages.vue';
import Mentions from './Mentions.vue';
import More from './More.vue';
import Threads from './Threads.vue';

export default {
  components: { Accordion, Drafts, DirectMessags, Mentions, More, Threads },
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
