<template>
  <div
    class="messageWrapper"
    @mouseover="emojiModalStatus = true"
    @mouseleave="emojiModalStatus = false"
  >
    <n-avatar
      v-show="!isSameUser"
      class="avatar"
      size="large"
      :src="message.sender.avatar"
    />
    <span class="message">
      <div>
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
      </div>
      <template v-for="emoji in allReactions" :key="emoji.id">
        <span class="emoji">{{ emoji.i }}</span>
      </template>

      <div
        class="emojiModalToggle"
        v-if="emojiModalStatus || openEmojiModal || showOptions"
      >
        <EmojiModalButton icon="fa-solid fa-square-check" btnText="Completed" />
        <EmojiModalButton icon="fa-solid fa-thumbs-up" btnText="Liked it" />
        <EmojiModalButton icon="fa-solid fa-heart" btnText="Loved it" />
        <EmojiModalButton
          icon="fa-solid fa-icons"
          btnText="Find another reaction"
          :action="setEmojiModal"
        />
        <EmojiModalButton
          icon="fa-solid fa-comment-dots"
          btnText="Reply in thread"
        />
        <EmojiModalButton icon="fa-solid fa-share" btnText="Share message..." />
        <EmojiModalButton
          icon="fa-solid fa-bookmark"
          btnText="Add to saved items"
        />
        <EmojiModalButton
          icon="fa-solid fa-ellipsis-vertical"
          btnText="More actions"
          :action="setOptionsModal"
        />
      </div>
    </span>
  </div>

  <div v-if="openEmojiModal" class="emojiModal">
    <EmojiPicker :addReaction="addReaction" />
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
import EmojiPicker from '../../../widgets/emojipicker.vue';
import EmojiModalButton from '../../../widgets/EmojiModalButton/index.vue';

export default {
  name: 'MessageWrapper',
  components: {
    NAvatar,
    EmojiPicker,
    EmojiModalButton,
  },
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
      emojiModalStatus: false,
      openEmojiModal: false,
      allReactions: [],
      showOptions: false,
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
  methods: {
    addReaction(emoji) {
      this.allReactions.push(emoji);
    },
    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },
    setOptionsModal() {
      this.showOptions = !this.showOptions;
      console.log(this.openEmojiModal);
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
  position: relative;
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

.emojiModal {
  position: absolute;
  right: 0;
  z-index: 98;
}

.emojiModalToggle {
  background-color: #ffffff;
  color: rgb(131, 130, 130);
  padding: 5px;
  border-radius: 4px;
  position: absolute;
  right: 30px;
  top: -22px;
}

.emoji {
  background-color: #151f252c;
  padding: 5px 8px;
  margin-right: 2px;
  border-radius: 5px;
}
</style>
