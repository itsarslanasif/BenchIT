<template>
  <div class="flex p-2 hover:bg-slate-100 relative m-0 text-sm" @mouseover="emojiModalStatus = true"
    @mouseleave="emojiModalStatus = false">
    <div class="min-w-fit">
      <n-avatar v-show="!isSameUser" class="self-baseline h-10 mr-1" size="large" :src="message.sender.avatar" />
    </div>
    <span>
      <div>
        <span class="flex items-center">
          <p v-show="!isSameUser" class="mr-1 hover:underline cursor-pointer">
            <b>{{ message.sender.name }}</b>
          </p>
          <p v-bind:class="{ time: !isSameUser, 'text-sm text-primary ml-2 mr-2 hover:underline cursor-pointer': isSameUser }">
            {{ isSameUser ? timeWithoutAMPM : time }}
          </p>
          <span v-show="isSameUser" class="word-break text-sm" v-html="message.content" />
        </span>
        <span v-show="!isSameUser" class="word-break text-sm" v-html="message.content" />
        <div class="flex text-sm ">
          <div v-for="emoji in allReactions">
            <span>{{ emoji.i }}</span>
          </div>
        </div>
      </div>
      <div class="bg-primaryHover right-0 mr-6 px-3 py-1 -mt-3 rounded-md absolute text-white"
        v-if="emojiModalStatus || openEmojiModal" @click="openEmojiModal = !openEmojiModal">
        <font-awesome-icon icon="fa-solid fa-face-smile-wink" />
      </div>
    </span>
  </div>

  <div v-if="openEmojiModal" class="absolute z-10 right-0 mr-6 top-3">
    <EmojiPicker :addReaction="addReaction" />
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
import EmojiPicker from '../../widgets/emojipicker.vue';
export default {
  name: 'MessageWrapper',
  components: { NAvatar, EmojiPicker },
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
  },
};
</script>
