<template>
  <div class="bg-white">
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
      class="flex p-1 relative hover:bg-transparent items-start flex-col"
      :class="{
        messageContentpinned: pinnedConversationStore.isPinned(currMessage),
      }"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <div
        class="flex m-1 text-xs text-black-600 font-semibold hover:underline cursor-pointer"
      >
        <div v-if="message.conversation_type == 'User'">Direct Message</div>
        <div v-else-if="message.conversation_type == 'BenchChannel'">
          {{ message.channel_name }}
        </div>
        <div v-else-if="message.conversation_type == 'Group'">
          Group Message
        </div>
      </div>
      <div class="flex">
        <div class="m-1">
          <n-avatar
            v-show="!isSameUser || !isSameDayMessage"
            size="large"
            src="../../../assets/images/user.png"
          />
        </div>
        <div>
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
          <div v-if="currMessage?.attachments" class="flex gap-2 mb-3">
            <div
              v-for="attachment in currMessage?.attachments"
              :key="attachment.id"
              class="w-64"
            >
              <p class="text-xs text-black-600">
                {{ attachment.attachment.filename }}
              </p>
              <img
                :src="attachment?.attachment_link"
                class="border border-black-300 rounded"
                :class="{ 'ml-12': isSameUser && isSameDayMessage }"
              />
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
            :actionText="$t('actions.remove_from_saved_items')"
            :action="unSave"
          />
          <EmojiModalButton
            icon="fa-solid fa-ellipsis-vertical"
            :actionText="$t('emojiModalButton.more_actions')"
            :action="setOptionsModal"
            :message="currMessage"
            :pinnedConversationStore="usePinnedConversation"
          />
        </div>
      </div>
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
import { unsave } from '../../../api/save_messages/unsavemessage.js';
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
        unsave(this.currMessage.message.id).then(() => {
          this.savedItemsStore.removeSavedItem(this.message);
        });
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
