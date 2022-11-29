<template>
  <div>
    <div class="items-center flex p-1 relative hover:bg-slate-100" @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false">
      <div class="min-w-fit ml-1">
        <n-avatar v-show="!isSameUser" class="mr-1 self-baseline" size="large" src="../../../assets/images/user.png" />
      </div>
      <span class="message">
        <div class="ml-1">
          <span class="items-center flex text-black-800 text-lg m-0">
            <p v-show="!isSameUser" class="mr-1 text-sm hover:underline cursor-pointer">
              <b>{{ message.sender_name }}</b>
            </p>
            <p class="text-xs" v-bind:class="{
              time: !isSameUser,
              'ml-2 mr-3 text-black-500 hover:underline cursor-pointer':
                isSameUser,
            }">
              {{ isSameUser ? timeWithoutAMPM : time }}
            </p>
            <span v-show="isSameUser" class="text-black-800 text-sm flex-wrap" v-html="message.content" />
          </span>
          <span v-show="!isSameUser" class="text-black-800 text-sm flex-wrap" v-html="message.content" />
        </div>
        <template v-for="emoji in allReactions" :key="emoji.id">
          <span class="bg-black-300 p-1 mr-1 rounded">{{ emoji.i }}</span>
        </template>
        <div class="bg-white text-black-500 p-1 rounded absolute top-0 right-0 -mt-3 mr-3 shadow-2xl"
          v-if="emojiModalStatus || openEmojiModal || showOptions">
          <template v-for="emoji in topReactions" :key="emoji">
            <EmojiModalButton :emoji="emoji" :actionText="emoji.n" :action="addReaction" />
          </template>
          <EmojiModalButton icon="fa-solid fa-icons" actionText="Find another reaction" :action="setEmojiModal" />
          <EmojiModalButton icon="fa-solid fa-comment-dots" actionText="Reply in thread" />
          <EmojiModalButton icon="fa-solid fa-share" actionText="Share message..." />
          <EmojiModalButton icon="fa-solid fa-bookmark" actionText="Add to saved items" />
          <EmojiModalButton icon="fa-solid fa-ellipsis-vertical" actionText="More actions" :action="setOptionsModal" />
        </div>
      </span>
    </div>
    <div v-if="openEmojiModal" class="absolute right-0 z-50">
      <EmojiPicker :addReaction="addReaction" />
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
import EmojiPicker from '../../widgets/emojipicker.vue';
import EmojiModalButton from '../../widgets/emojiModalButton.vue';
import user from '../../../assets/images/user.png';

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
  mounted() {
    console.log(user)
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
      return moment(new Date(this.message.created_at).getTime()).format(
        'h:mm A'
      );
    },
    timeWithoutAMPM() {
      return moment(new Date(this.message.created_at).getTime()).format('h:mm');
    },
    isSameUser() {
      if (this.oldMessage === undefined) return false;
      return this.message?.sender_id === this.oldMessage?.sender_id;
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
