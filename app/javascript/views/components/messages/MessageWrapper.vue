<template>
  <div
    :style="this.currMessage.isSaved ? { 'background-color': '#fffff0' } : null"
  >
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
      class="flex p-1 relative hover:bg-transparent"
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
        <div v-if="this.currMessage.isSaved" class="flex items-center">
          <i class="far fa-bookmark text-red-500"></i>
          <p class="ml-2">{{ $t('actions.save_items') }}</p>
        </div>
        <div class="ml-1">
          <span class="items-center flex text-black-800 text-lg m-0">
            <p
              v-show="!isSameUser || !isSameDayMessage"
              class="mr-1 text-sm hover:underline cursor-pointer"
            >
              <b>{{ currMessage.sender_name }}</b>
            </p>
            <p
              class="text-xs ml-2 mr-3 text-black-500 hover:underline cursor-pointer"
            >
              {{ isSameUser && isSameDayMessage ? timeWithoutAMPM : time }}
            </p>
            <span
              v-show="isSameUser && isSameDayMessage"
              class="text-black-800 text-sm flex-wrap"
              v-html="currMessage.content"
            />
          </span>
          <span
            v-show="!isSameUser || !isSameDayMessage"
            class="text-black-800 text-sm flex-wrap"
            v-html="currMessage.content"
          />
          <div v-if="message.attachments" class="flex gap-2">
            <div v-for="attachment in message.attachments" class="w-64">
              <img :src="attachment.attachment_link" class="rounded" />
            </div>
          </div>
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
          <EmojiModalButton
            icon="fa-solid fa-icons"
            :actionText="$t('emojiModalButton.find_another_reaction')"
            :action="setEmojiModal"
          />
          <EmojiModalButton
            icon="fa-solid fa-comment-dots"
            :actionText="$t('emojiModalButton.reply_in_thread')"
          />
          <EmojiModalButton
            icon="fa-solid fa-share"
            :actionText="$t('emojiModalButton.share_message')"
          />
          <EmojiModalButton
            icon="fa-solid fa-bookmark"
            :actionText="$t('emojiModalButton.add_to_saved_items')"
            :action="saveMessage"
          />
          <EmojiModalButton
            icon="fa-solid fa-ellipsis-vertical"
            :actionText="$t('emojiModalButton.more_actions')"
            :action="setOptionsModal"
            :message="currMessage"
            :pinnedConversationStore="usePinnedConversation"
          />
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
import { save } from '../../../api/save_messages/savemessage.js';
import { unsave } from '../../../api/save_messages/unsavemessage.js'
import { CONSTANTS } from '../../../assets/constants';
import { useSavedItemsStore } from '../../../stores/useSavedItemStore';


export default {
  name: 'MessageWrapper',
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    const savedItemsStore = useSavedItemsStore();
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
    prevMessage: {
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
      oldMessage: this.prevMessage,
      emojiModalStatus: false,
      openEmojiModal: false,
      allReactions: [],
      showOptions: false,
    };
  },
  computed: {
    time() {
      return moment(new Date(this.currMessage.created_at).getTime()).format(
        'h:mm A'
      );
    },
    timeWithoutAMPM() {
      return moment(new Date(this.currMessage.created_at).getTime()).format(
        'h:mm'
      );
    },
    isSameUser() {
      if (this.prevMessage === undefined) return false;
      return this.currMessage?.sender_id === this.prevMessage?.sender_id;
    },
    isSameDayMessage() {
      return (
        new Date(this.currMessage?.created_at).toDateString() ===
        new Date(this.prevMessage?.created_at).toDateString()
      );
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
    saveMessage() {
      this.currMessage.isSaved = !this.currMessage.isSaved;
      if (this.currMessage.isSaved) {
        save(this.message.id,
          {
            data: this.message
          }).then(() => {
            this.savedItemsStore.addSavedItem(this.message);
          }
          )
      }
      else {
        unsave(this.message.id).then(() => {
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
