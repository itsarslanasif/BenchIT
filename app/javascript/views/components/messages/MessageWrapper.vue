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
    <div v-if="this.currMessage.isSaved" class="flex ml-4 items-center">
      <i class="far fa-bookmark text-red-500"></i>
      <p class="ml-2">{{ $t('actions.save_items') }}</p>
    </div>
    <div
      class="flex p-1 px-4 relative hover:bg-transparent"
      :class="{
        'bg-yellow-100': pinnedConversationStore.isPinned(currMessage),
      }"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <template v-if="!isSameUser || !isSameDayMessage">
        <user-profile-modal :profile_id='currMessage.sender_id' />
      </template>
      <span class="message">
        <div class="ml-1">
          <span class="items-center flex text-black-800 text-lg m-0">
            <p
              @click="showUserProfile"
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
          <div v-if="currMessage?.attachments" class="flex gap-2">
            <div
              v-for="attachment in currMessage?.attachments"
              :key="attachment.id"
              class="w-64"
            >
              <img
                :src="attachment?.attachment_link"
                class="rounded"
                :class="{ 'ml-12': isSameUser && isSameDayMessage }"
              />
            </div>
          </div>
        </div>
        <template v-for="emoji in allReactions" :key="emoji.id">
          <span
            @click="emojiClickListener(emoji)"
            class="bg-black-300 p-1 mr-1 rounded"
            >{{ emoji.emoji }}</span
          >
        </template>
        <div
          v-if="currMessage?.is_threaded"
          @click="toggleThread"
          :class="{ 'ml-12': isSameUser && isSameDayMessage }"
          class="text-info text-xs cursor-pointer hover:underline"
        >
          {{ repliesCount }}
        </div>
        <div
          class="bg-white text-black-500 p-2 border border-slate-100 rounded absolute top-0 right-0 -mt-8 mr-3 shadow-xl"
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
            v-if="!currMessage.parent_message_id"
            icon="fa-solid fa-comment-dots"
            :actionText="$t('emojiModalButton.reply_in_thread')"
            :action="toggleThread"
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
import { NAvatar, NCard, NDivider} from 'naive-ui';
import EmojiPicker from '../../widgets/emojipicker.vue';
import EmojiModalButton from '../../widgets/emojiModalButton.vue';
import { useThreadStore } from '../../../stores/useThreadStore';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import { save } from '../../../api/save_messages/savemessage.js';
import { unsave } from '../../../api/save_messages/unsavemessage.js';
import { CONSTANTS } from '../../../assets/constants';
import { useSavedItemsStore } from '../../../stores/useSavedItemStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import UserProfileModal from '../../widgets/UserProfileModal.vue';
import { add_reaction } from '../../../api/reactions/reaction.js';
import { remove_reaction } from '../../../api/reactions/reaction.js';
import { useCurrentUserStore } from '../../../stores/useCurrentUserStore';
import { getUserProfile } from '../../../api/profiles/userProfile';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';

export default {
  name: 'MessageWrapper',
  setup() {
    const threadStore = useThreadStore();
    const pinnedConversationStore = usePinnedConversation();
    const savedItemsStore = useSavedItemsStore();
    const rightPaneStore = useRightPaneStore();
    const currentUserStore = useCurrentUserStore();
    const userProfileStore = useUserProfileStore();
    return {
      threadStore,
      pinnedConversationStore,
      savedItemsStore,
      currentUserStore,
      rightPaneStore,
      userProfileStore
    };
  },
  components: {
    NAvatar, NCard, NDivider,
    EmojiPicker,
    EmojiModalButton,
    UserProfileModal
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
      emojiModalStatus: false,
      openEmojiModal: false,
      allReactions: this.currMessage.reactions,
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
    repliesCount() {
      return `${this.currMessage.replies?.length} replies..`;
    },
  },
  methods: {
    async addReaction(emoji) {
      await add_reaction(this.currMessage.id, emoji.i).then(response => {
        return this.allReactions.push(response.data);
      });
    },

    async emojiClickListener(emoji) {
      if (emoji.user_id == this.currentUserStore.currentUser.id) {
        await remove_reaction(emoji.id).then(() => {
          this.allReactions = this.allReactions.filter(function (reaction) {
            return reaction.id != emoji.id;
          });
        });
      }
    },

    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },

    setOptionsModal() {
      this.showOptions = !this.showOptions;
    },

    toggleThread() {
      this.threadStore.setMessage(this.currMessage);
      this.rightPaneStore.toggleThreadShow(true);
    },

    showUserProfile() {
      this.setUserProfileForPane();
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    async setUserProfileForPane() {
      this.userProfileStore.setUserProfile(
        await getUserProfile(1, this.currMessage.sender_id)
      );
    },

    saveMessage() {
      this.currMessage.isSaved = !this.currMessage.isSaved;
      if (this.currMessage.isSaved) {
        save(this.currMessage.id, {
          data: this.currMessage,
        }).then(() => {
          this.savedItemsStore.addSavedItem(this.currMessage);
        });
      } else {
        unsave(this.currMessage.id).then(() => {
          this.savedItemsStore.removeSavedItem(this.currMessage);
        });
      }
    },
  },
};
</script>
