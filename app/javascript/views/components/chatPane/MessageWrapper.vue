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
        <template v-for="emoji in topReactions" :key="emoji">
          <EmojiModalButton
            :emoji="emoji"
            :actionText="emoji.n"
            :action="addReaction"
          />
        </template>
        <EmojiModalButton
          icon="fa-solid fa-icons"
          actionText="Find another reaction"
          :action="setEmojiModal"
        />
        <EmojiModalButton
          icon="fa-solid fa-comment-dots"
          actionText="Reply in thread"
        />
        <EmojiModalButton
          icon="fa-solid fa-share"
          actionText="Share message..."
        />
        <EmojiModalButton
          icon="fa-solid fa-bookmark"
          actionText="Add to saved items"
        />
        <EmojiModalButton
          icon="fa-solid fa-ellipsis-vertical"
          actionText="More actions"
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
      topReactions: [
        {
          i: '✅',
          n: 'Completed',
        },
        {
          i: '👍',
          n: 'Liked it',
        },
        {
          i: '👀',
          n: 'Taking a look',
        },
      ],
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
      console.log(this.allReactions[0]);
    },
    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },
    setOptionsModal() {
      this.showOptions = !this.showOptions;
    },
  },
};
</script>
<style>
p {
  @apply text-black-800 text-xs m-0;
}

.messageContent {
  @apply text-black-800 text-xs flex-wrap;
}

.messageWrapper {
  @apply items-center flex p-1 relative;
}

.messageWrapper:hover {
  @apply bg-black-200;
}

.name {
  @apply mr-1;
  font-size: 14px;
}

.name:hover {
  @apply cursor-pointer underline;
}

.time {
  @apply text-black-500;
  font-size: x-small;
}

.time:hover {
  @apply cursor-pointer underline;
}

.time-on-left {
  @apply ml-2 mr-3 text-black-500;
  font-size: x-small;
}

.time-on-left:hover {
  @apply cursor-pointer underline;
}

.messageInfo {
  @apply items-center flex;
}

.avatar {
  @apply h-8 mr-1;
  align-self: baseline;
  min-width: fit-content;
}

.emojiModal {
  @apply absolute right-0 z-50;
}

.emojiModalToggle {
  @apply bg-white text-black-500 p-1 rounded absolute;
  right: 30px;
  top: -22px;
}

.emoji {
  @apply bg-black-300 p-1 mr-1 rounded;
}
</style>
