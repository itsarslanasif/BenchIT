<template>
  <div class="messageWrapper">
    <n-avatar
      v-show="!isSameUser"
      class="avatar"
      size="large"
      :src="message.sender.avatar"
    />
    <span class="message">
      <span class="messageInfo">
        <p v-show="!isSameUser" class="name">
          <b>{{ message.sender.name }}</b>
        </p>
        <p v-bind:class="{ time: !isSameUser, 'time-on-left': isSameUser }">
          {{ isSameUser ? timeWithoutAMPM : time }}
        </p>
        <span
          v-show="isSameUser"
          class="messageContent"
          v-html="message.content"
        />
      </span>
      <span
        v-show="!isSameUser"
        class="messageContent"
        v-html="message.content"
      />
    </span>
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
export default {
  name: 'MessageWrapper',
  components: { NAvatar },
  props: {
    currMessage: {
      type: Object,
      default: undefined,
    },
    prevMessage: {
      type: Object,
      default: undefined,
    },
  },
  data() {
    return {
      message: this.currMessage,
      oldMessage: this.prevMessage,
    };
  },
  computed: {
    time() {
      return moment(new Date(this.message.sentAt).getTime()).format('h:mm A');
    },
    timeWithoutAMPM() {
      return moment(new Date(this.message.sentAt).getTime()).format('h:mm');
    },
    isSameUser() {
      if (this.oldMessage === undefined) return false;
      return this.message?.sender.id === this.oldMessage?.sender.id;
    },
  },
};
</script>
<style scoped>
p {
  color: rgb(52, 51, 51);
  font-size: 14px;
  margin: 0px;
}
.messageContent {
  color: rgb(52, 51, 51);
  font-size: 14px;
  word-wrap: normal;
}
.messageWrapper {
  align-items: center;
  display: flex;
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
.time-on-left {
  color: grey;
  font-size: x-small;
  margin-left: 16px;
  margin-right: 8px;
}
.time-on-left:hover {
  cursor: pointer;
  text-decoration: underline;
}
.messageInfo {
  align-items: center;
  display: flex;
}
.avatar {
  align-self: baseline;
  height: 40px;
  margin-right: 5px;
  min-width: fit-content;
}
</style>
