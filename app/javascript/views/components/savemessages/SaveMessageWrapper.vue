<template>
  <div class="bg-transparent">
    <div v-if="pinnedConversationStore.isPinned(currMessage)">
      <span
        class="p-1 items-center text-black-800 text-xs flex bg-yellow-100 relative"
      >
        <font-awesome-icon class="p-1" icon="fa-solid fa-thumbtack" />
        {{ $t('pinconversation.pinned_by') }}
        {{ $t('pinconversation.you') }}
      </span>
    </div>
    <div
      class="items-center flex p-1 relative hover:bg-transparent"
      :class="{
        messageContentpinned: pinnedConversationStore.isPinned(currMessage),
      }"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <div class="min-w-fit ml-1">
        <n-avatar
          v-show="!isSameUser || !isSameDayMessage"
          class="mr-1 self-baseline"
          size="large"
          src="../../../assets/images/user.png"
        />
      </div>
      <span class="message">
        <div class="ml-1">
          <span class="items-center flex text-black-800 text-lg m-0">
            <p
              v-show="!isSameUser || !isSameDayMessage"
              class="mr-1 text-sm hover:underline cursor-pointer"
            >
              <b>{{ currMessage.profile.name }}</b>
            </p>
            <p
              class="text-xs ml-2 mr-3 text-black-500 hover:underline cursor-pointer"
            >
              {{ currMessage.message.created_at ? timeWithoutAMPM : time }}
            </p>
          </span>
          <span
            class="text-black-800 text-sm flex-wrap"
            v-html="currMessage.message.content"
          />
        </div>
        <template v-for="emoji in allReactions" :key="emoji.id">
          <span class="bg-black-300 p-1 mr-1 rounded">{{ emoji.i }}</span>
        </template>
        <div
          class="bg-white text-black-500 p-1 rounded absolute top-0 right-0 -mt-3 mr-3 shadow-2xl"
          v-if="emojiModalStatus || openEmojiModal || showOptions"
        >
          <template v-for="emoji in topReactions" :key="emoji">
            <EmojiModalButton
              :emoji="emoji"
              :actionText="emoji.n"
              :action="addReaction"
            />
          </template>
          <EmojiModalButton icon="fa-solid fa-icons" :actionText="$t('emojiModalButton.find_another_reaction')"
            :action="setEmojiModal" />
          <EmojiModalButton icon="fa-solid fa-comment-dots" :actionText="$t('emojiModalButton.reply_in_thread')" />
          <EmojiModalButton icon="fa-solid fa-share" :actionText="$t('emojiModalButton.share_message')" />
          <EmojiModalButton icon="fa-solid fa-bookmark" :actionText="$t('actions.remove_from_saved_items')"
            :action="unSave" />
          <EmojiModalButton icon="fa-solid fa-ellipsis-vertical" :actionText="$t('emojiModalButton.more_actions')"
            :action="setOptionsModal" :message="currMessage" :pinnedConversationStore="usePinnedConversation" />
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
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import { unsave } from '../../../api/save_messages/unsavemessage.js'
import { useSavedItemsStore } from '../../../stores/useSavedItemStore.js';
import { CONSTANTS } from '../../../assets/constants';

export default {
  name: 'MessageWrapper',
  setup() {
    const savedItemsStore = useSavedItemsStore();
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore, savedItemsStore };
  },
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
  },
  data() {
    return {
      topReactions: [
        {
          i: CONSTANTS.COMPLETED_EMOJI,
          n: CONSTANTS.COMPLETED,
        },
        {
          i: CONSTANTS.LIKED_IT_EMOJI,
          n: CONSTANTS.LIKED_IT,
        },
        {
          i: CONSTANTS.TAKING_A_LOOK_EMOJI,
          n: CONSTANTS.TAKING_A_LOOK,
        },
      ],
      message: this.currMessage,
      emojiModalStatus: false,
      openEmojiModal: false,
      allReactions: [],
      showOptions: false,
    };
  },
  computed: {
    time() {
      return moment(
        new Date(this.currMessage.message.created_at).getTime()
      ).format('h:mm A');
    },
    timeWithoutAMPM() {
      return moment(
        new Date(this.currMessage.message.created_at).getTime()
      ).format('h:mm');
    },
  },
  methods: {
    addReaction(emoji) {
      axios.post('http://127.0.0.1:5100/api/v1/reactions', {
        conversation_message_id: this.currMessage.id,
        emoji: emoji.i,
      });
      this.allReactions.push(this.currMessage.reactions[0].emoji);
    },
    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },
    setOptionsModal() {
      this.showOptions = !this.showOptions;
    },
    unSave() {
      if (this.currMessage.isSaved) {
        unsave(this.currMessage.message.id).
          then(() => {
            this.savedItemsStore.removeSavedItem(this.message);
          })
      }
    },
  },
};
</script>
<style scoped>
.messageContentpinned {
  @apply bg-yellow-100;
}
</style>
