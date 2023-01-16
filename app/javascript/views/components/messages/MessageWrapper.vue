<template>
  <div
    class="py-1"
    :style="this.currMessage.isSaved ? { 'background-color': '#fffff0' } : null"
  >
    <div v-if="currMessage.pinned">
      <span
        class="pl-4 items-center text-black-800 text-xs flex bg-yellow-50 relative"
      >
        <font-awesome-icon class="p-1" icon="fa-solid fa-thumbtack" />
        {{ $t('pinconversation.pinned_by') }}
        {{ currMessage.pin.pinned_by }}
      </span>
    </div>
    <div v-if="this.currMessage.isSaved" class="flex ml-4 items-center">
      <i class="far fa-bookmark text-red-500"></i>
      <p class="ml-2">{{ $t('actions.save_items') }}</p>
    </div>
    <div
      class="flex p-1 px-4 hover:bg-transparent relative"
      :class="{
        'bg-yellow-50': currMessage.pinned,
      }"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <template v-if="!isSameUser || !isSameDayMessage || isFirstMessage">
        <user-profile-modal
          :profile_id="currMessage.sender_id"
          :sender_avatar="currMessage.sender_avatar"
        />
      </template>
      <span class="message">
        <div class="ml-1">
          <span class="items-center flex text-black-800 text-lg m-0">
            <p
              @click="showUserProfile"
              v-if="!isSameUser || !isSameDayMessage || isFirstMessage"
              class="mr-1 text-sm hover:underline cursor-pointer"
            >
              <b>{{ currMessage.sender_name }}</b>
            </p>
            <span
              :class="{
                'flex w-12': isSameUser && isSameDayMessage && !isFirstMessage,
              }"
            >
              <p
                class="text-xs ml-1 mr-3 text-black-500 hover:underline cursor-pointer"
              >
                {{
                  isSameUser && isSameDayMessage && !isFirstMessage
                    ? timeWithoutAMPM
                    : time
                }}
              </p>
            </span>
            <span
              v-if="isSameUser && isSameDayMessage && !isFirstMessage"
              class="text-black-800 text-sm flex-wrap"
              v-html="currMessage.content"
            />
          </span>
          <span
            v-if="!isSameUser || !isSameDayMessage || isFirstMessage"
            class="text-black-800 text-sm flex-wrap"
            v-html="currMessage.content"
          />
          <div v-if="currMessage.attachments" class="flex gap-2">
            <div
              v-for="attachment in currMessage.attachments"
              :key="attachment.id"
              class="w-64"
            >
              <n-popover
                class="rounded-md border-black-300 border text-black-600"
                placement="top-end"
                trigger="hover"
                :show-arrow="false"
              >
                <template #trigger>
                  <img
                    :src="attachment.attachment_link"
                    class="rounded"
                    :class="{ 'ml-12': isSameUser && isSameDayMessage }"
                  />
                </template>
                <a :href="attachment.attachment_download_link" download>
                  <span class="mr-3" @click="downloadFile(attachment)">
                    <font-awesome-icon icon="fa-solid fa-cloud-arrow-down" />
                  </span>
                </a>
                <downloadsModal
                  icon="fa-solid fa-share"
                  :actionText="$t('downloadsModal.share_file')"
                />
                <downloadsModal
                  icon="fa-solid fa-ellipsis-vertical"
                  :actionText="$t('emojiModalButton.more_actions')"
                  :action="setFileOptionsModal"
                />
              </n-popover>
            </div>
          </div>
        </div>
        {{ displayReaction }}
        <template v-for="emoji in displayedReactions" :key="emoji">
          <div
            @click="addReaction(emoji)"
            :class="[
              { 'bg-blue-100 border-blue-200': isCurrentUserReaction(emoji) },
              { 'ml-12 -mr-10': isSameUser && isSameDayMessage },
            ]"
            class="mt-1 inline-flex mr-1 w-12 h-7 bg-black-200 rounded-xl cursor-pointer justify-center border border-black-200 hover:border-black-500 hover:bg-white"
          >
            <n-tooltip
              placement="top"
              :style="{ width: '170px' }"
              trigger="hover"
            >
              <template #trigger>
                <n-text class="ml-1"
                  >{{ emoji }}
                  <span class="text-xs ml-1">{{
                    countReaction(emoji)
                  }}</span></n-text
                >
              </template>
              <div class="flex flex-col items-center">
                <span class="text-3xl bg-white rounded text-center w-12">{{
                  emoji
                }}</span>
                <span class="text-md"
                  >{{ getUsers(emoji, currentUserStore.currentUser.name) }}
                  {{ $t('chat.reacted') }}</span
                >
              </div>
            </n-tooltip>
          </div>
        </template>
        <reply-and-thread-button
          v-if="currMessage?.replies?.length > 0 && !inThread"
          :currMessage="currMessage"
          :isSameDayMessage="isSameDayMessage"
          :isSameUser="isSameUser"
          :lastReply="lastReply"
          :lastThreeRepliesOfUniqueUsers="lastThreeRepliesOfUniqueUsers"
          :repliesCount="repliesCount"
          :toggleThread="toggleThread"
          :isFirstMessage="isFirstMessage"
        />
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
    <div v-if="openEmojiModal" class="float-right mr-4">
      <EmojiPicker :addReaction="addReaction" />
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { NCard, NDivider, NTooltip, NButton, NText, NPopover } from 'naive-ui';
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
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import downloadsModal from '../../widgets/downloadsModal/downloadsModal.vue';
import { fileDownload } from '../../../api/downloads/downloads.js';
import { useDownloadsStore } from '../../../stores/useDownloadsStore';
import benchitAlert from '../../widgets/benchitAlert.vue';
import ReplyAndThreadButton from '../../widgets/ReplyAndThreadButton.vue';

export default {
  name: 'MessageWrapper',
  setup() {
    const threadStore = useThreadStore();
    const pinnedConversationStore = usePinnedConversation();
    const savedItemsStore = useSavedItemsStore();
    const rightPaneStore = useRightPaneStore();
    const currentUserStore = useCurrentUserStore();
    const userProfileStore = useUserProfileStore();
    const profilesStore = useProfileStore();
    const messagesStore = useMessageStore();
    const downloadsStore = useDownloadsStore();
    return {
      threadStore,
      pinnedConversationStore,
      savedItemsStore,
      currentUserStore,
      rightPaneStore,
      userProfileStore,
      profilesStore,
      messagesStore,
      downloadsStore,
    };
  },
  components: {
    NCard,
    NDivider,
    EmojiPicker,
    EmojiModalButton,
    UserProfileModal,
    NTooltip,
    NButton,
    NText,
    NPopover,
    downloadsModal,
    benchitAlert,
    ReplyAndThreadButton,
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
    inThread: {
      type: Boolean,
      default: false,
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
      showOptions: false,
      displayedReactions: [],
      showFileOptions: false,
    };
  },
  beforeUnmount() {
    this.topReactions = null;
    this.displayedReactions = null;
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
      let count = this.currMessage.replies?.length;
      return count > 1
        ? `${count} ${CONSTANTS.REPLIES}`
        : `${count} ${CONSTANTS.REPLY}`;
    },
    isFirstMessage() {
      if (this.messagesStore.messages) {
        return this.firstMessageId === this.currMessage?.id;
      }
    },
    firstMessageId() {
      return this.messagesStore.messages[0]?.id;
    },
    displayReaction() {
      this.currMessage.reactions.filter(reaction => {
        const isDuplicate = this.displayedReactions.includes(reaction.emoji);
        if (!isDuplicate) {
          this.displayedReactions.push(reaction.emoji);
          return true;
        }
        return false;
      });
    },
    isSuccessfullResponse() {
      return this.error === false;
    },
    lastReply() {
      return this.currMessage.replies[this.currMessage.replies?.length - 1];
    },
    lastThreeRepliesOfUniqueUsers() {
      return this.currMessage?.replies
        ?.reduce(
          (prev, reply) =>
            prev.find(item => item.sender_id === reply.sender_id)
              ? prev
              : [...prev, reply],
          []
        )
        ?.slice(-3);
    },
  },
  methods: {
    async addReaction(emoji) {
      let temp = null;
      if (typeof emoji === 'object') {
        temp = emoji.i;
      } else {
        temp = emoji;
      }
      let emoji_id = null;
      if (
        this.currMessage.reactions.some(reaction => {
          return (
            (emoji_id = reaction.id),
            reaction.emoji === temp &&
              reaction.profile_id === this.currentUserStore.currentUser.id
          );
        })
      ) {
        try {
          await remove_reaction(emoji_id);
        } catch (e) {
          console.error(e);
        }
      } else {
        try {
          await add_reaction(this.currMessage.id, temp);
        } catch (e) {
          console.error(e);
        }
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

    setUserProfileForPane() {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === this.currMessage.sender_id
      );
      this.userProfileStore.setUserProfile(profile);
    },

    saveMessage() {
      this.currMessage.isSaved = !this.currMessage.isSaved;
      try {
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
      } catch (e) {
        console.error(e);
      }
    },

    countReaction(emoji) {
      const filteredReactions = this.currMessage.reactions.filter(function (
        reaction
      ) {
        return reaction.emoji === emoji;
      });
      if (filteredReactions.length === 0) {
        this.displayedReactions = this.displayedReactions.filter(function (
          reaction
        ) {
          return reaction != emoji;
        });
      }
      return filteredReactions.length;
    },

    getUsers(emoji, name) {
      let users = this.currMessage.reactions
        .filter(function (reaction) {
          return reaction.emoji === emoji;
        })
        .map(function (reaction) {
          if (reaction.reacted_by === name) {
            return CONSTANTS.YOU;
          } else {
            return reaction.reacted_by;
          }
        });
      const formatter = new Intl.ListFormat('en', {
        style: 'long',
        type: 'conjunction',
      });
      users = users.filter(function (user) {
        return user !== undefined;
      });
      return formatter.format(users);
    },

    isCurrentUserReaction(emoji) {
      return this.currMessage.reactions.some(reaction => {
        return (
          reaction.emoji === emoji &&
          reaction.profile_id === this.currentUserStore.currentUser.id
        );
      });
    },

    downloadFile(attachment) {
      try {
        fileDownload(attachment).then(response => {
          this.downloadsStore.downloads.unshift(response.data);
          this.downloadsStore.response = response;
          this.downloadsStore.downloadAlert = true;
        });
        this.downloadsStore.downloadAlert = false;
      } catch (error) {
        this.downloadsStore.downloadAlert = true;
      }
    },

    setFileOptionsModal() {
      this.showFileOptions = !this.showFileOptions;
    },
  },
};
</script>
