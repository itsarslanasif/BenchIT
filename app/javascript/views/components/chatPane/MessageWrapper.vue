<template>
  <div class="messageWrapper">
    <img :src="message.sender.avatar" class="avatar" />
    <span class="message">
      <span class="messageInfo">
        <p class="name">
          <b>{{ message.sender.name }}</b>
        </p>
        <p class="time">
          {{ time }}
        </p>
      </span>
      <span class="messageContent" v-html="message.content" />
    </span>
  </div>
</template>

<script>
import moment from 'moment';
export default {
  name: 'MessageWrapper',
  props: {
    message: {
      type: Object,
      default: undefined,
    },
  },
  computed: {
    time() {
      return moment().format('hh:mm A');
    },
  },
};
</script>

<style scoped>
p {
  color: rgb(69, 68, 68);
  font-size: 14px;
  margin: 0px;
}

.messageContent {
  color: rgb(69, 68, 68);
  font-size: 14px;
  word-wrap: normal;
}
.messageWrapper {
  align-items: center;
  display: flex;
  margin-bottom: 5px;
  padding: 5px;
}
.messageWrapper:hover {
  background-color: rgb(230, 232, 234);
}
.name {
  margin-right: 5px;
}
.name:hover {
  cursor: pointer;
  text-decoration: underline;
}
.time {
  color: grey;
  font-size: x-small;
}
.time:hover {
  cursor: pointer;
  text-decoration: underline;
}
.messageInfo {
  align-items: center;
  display: flex;
}
.avatar {
  background: rgb(171, 170, 170);
  border-radius: 3px;
  height: 40px;
  margin-right: 5px;
  width: fit-content;
  align-self: baseline;
}
</style>
