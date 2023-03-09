<template>
  <div
    v-for="block in messageBlock.blocks"
    :key="block"
    class="py-1"
    :class="{
      'bg-yellow-50': isSavedMessage,
    }"
  >
    <div v-if="!currMessage.info && currMessage.pinned">
      <span
        class="pl-4 items-center text-black-800 text-xs flex bg-yellow-50 relative"
      >
        <font-awesome-icon class="p-1" icon="fa-solid fa-thumbtack" />
        {{ $t('pinconversation.pinned_by') }}
        {{ currMessage.pin.pinned_by }}
      </span>
    </div>
    <div v-if="isSavedMessage" class="flex ml-4 items-center bg-yellow-50">
      <i class="far fa-bookmark text-red-500"></i>
      <p class="ml-2">{{ $t('actions.save_items') }}</p>
    </div>
    <div
      class="hover-trigger flex p-1 px-4 hover:bg-transparent relative"
      :class="{
        'bg-yellow-50': currMessage.pinned,
      }"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <template v-if="isDeleted">
        <div
          class="h-10 w-10 min-w-10 mr-1 ml-1 bg-black-200 text-center rounded flex justify-center items-center"
        >
          <font-awesome-icon
            icon="fa-solid fa-trash-can"
            class="text-xl text-black-500"
          />
        </div>
      </template>
      <template
        v-if="
          (!isSameUser ||
            !isSameDayMessage ||
            isFirstMessage ||
            currMessage.is_info) &&
          !isDeleted
        "
      >
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
              v-if="
                (!isSameUser ||
                  !isSameDayMessage ||
                  isFirstMessage ||
                  currMessage.is_info) &&
                !isDeleted
              "
              class="mr-1 text-sm hover:underline cursor-pointer"
            >
              <b>{{ currMessage.sender_name }}</b>
            </p>
            <span
              :class="{
                'flex w-12':
                  !isDeleted &&
                  isSameUser &&
                  isSameDayMessage &&
                  !isFirstMessage,
              }"
            >
              <p
                class="text-xs ml-1 text-black-500 hover:underline cursor-pointer"
                :class="{
                  'hover-target w-12':
                    !isDeleted &&
                    isSameUser &&
                    isSameDayMessage &&
                    !isFirstMessage,
                }"
              >
                {{
                  isDeleted
                    ? null
                    : currMessage.is_info
                    ? time
                    : isSameUser && isSameDayMessage && !isFirstMessage
                    ? timeWithoutAMPM
                    : time
                }}
              </p>
            </span>
            <div>
              <div
                v-if="
                  isSameUser &&
                  isSameDayMessage &&
                  !isFirstMessage &&
                  !currMessage.is_info &&
                  !isDeleted
                "
              >
                <MessageSection
                  v-if="block.type === 'section'"
                  :section="block"
                />
                <div v-if="isSharedMessage" class="flex ml-4 flex-center">
                  <ShareMessageVue
                    :inThread="inThread"
                    :currMessage="currMessage.shared_message"
                  />
                </div>
              </div>
            </div>
            <span
              v-if="
                isSameUser && isSameDayMessage && !isFirstMessage && isDeleted
              "
              class="text-black-600 text-sm flex mt-2"
              >{{ $t('deleteMessageModal.success') }}</span
            >
            <EditedAtTime
              v-if="
                currMessage.is_edited &&
                isSameUser &&
                isSameDayMessage &&
                !isFirstMessage &&
                !isDeleted
              "
              :updated_at="currMessage.updated_at"
            />
          </span>
          <span
            v-if="
              (!isSameUser ||
                !isSameDayMessage ||
                isFirstMessage ||
                currMessage.is_info) &&
              !isDeleted
            "
          >
            <div class="flex">
              <span
                :class="
                  currMessage.is_info ? 'text-black-600' : 'text-black-800'
                "
                class="text-sm flex-wrap"
              >
                <MessageSection
                  v-if="block.type === 'section'"
                  :section="block"
                />
              </span>
              <EditedAtTime
                v-if="currMessage.is_edited && isDeleted"
                :updated_at="currMessage.updated_at"
              />
            </div>
            <div v-if="isSharedMessage" class="flex -ml-12 flex-center">
              <ShareMessageVue
                :inThread="inThread"
                :currMessage="currMessage.shared_message"
              />
            </div>
          </span>
          <span
            v-if="
              (!isSameUser || !isSameDayMessage || isFirstMessage) &&
              JSON.parse(this.currMessage.content).blocks[0].text.text ===
                $t('deleteMessageModal.success')
            "
            class="text-black-600 text-sm flex mt-2"
          >
            {{ $t('deleteMessageModal.success') }}</span
          >
          <div
            v-if="!currMessage.info && currMessage.attachments"
            class="flex gap-10"
          >
            <div
              v-for="attachment in currMessage.attachments"
              :key="attachment.attachment.id"
              class="w-64"
            >
              {{ setAttachment(attachment) }}
              <div
                v-if="isAudioFile"
                :class="{
                  'ml-12': isSameUser && isSameDayMessage && !isFirstMessage,
                }"
              >
                <visualize-voice
                  :fileID="currAttachment.attachment.id"
                  :audioURL="currAttachment.attachment_link"
                />
              </div>
              <n-popover
                v-if="!isAudioFile"
                class="rounded-md border-black-300 border text-black-600"
                placement="top-end"
                trigger="hover"
                :show-arrow="false"
              >
                <template #trigger>
                  <div
                    :class="{
                      'ml-12':
                        isSameUser && isSameDayMessage && !isFirstMessage,
                    }"
                    v-if="isTxtFile"
                  >
                    <font-awesome-icon
                      class="w-10 h-10"
                      icon="fa-solid fa-file"
                    />
                  </div>
                  <div
                    :class="{
                      'ml-12':
                        isSameUser && isSameDayMessage && !isFirstMessage,
                    }"
                    v-if="isVideoFile"
                  >
                    <video controls :src="attachment.attachment_link"></video>
                  </div>
                  <img
                    v-if="!isVideoFile && !isTxtFile"
                    :src="attachment.attachment_link"
                    class="rounded"
                    :class="{
                      'ml-12':
                        isSameUser && isSameDayMessage && !isFirstMessage,
                    }"
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
              {
                'ml-12 -mr-10':
                  !currMessage.is_info &&
                  isSameUser &&
                  isSameDayMessage &&
                  !isFirstMessage,
              },
            ]"
            class="mt-1 mr-1 w-12 h-7 bg-black-200 rounded-xl cursor-pointer justify-center border border-black-200 hover:border-black-500 hover:bg-white"
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
                  >{{ getUsers(emoji, currentProfile.username) }}
                  {{ $t('chat.reacted') }}</span
                >
              </div>
            </n-tooltip>
          </div>
        </template>
        <reply-and-thread-button
          v-if="
            !currMessage.info && currMessage?.replies?.length > 0 && !inThread
          "
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
          v-if="
            (emojiModalStatus || openEmojiModal || showOptions) &&
            JSON.parse(this.currMessage.content).blocks[0].text.text !==
              $t('deleteMessageModal.success')
          "
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
            v-if="!currMessage.parent_message_id && !currMessage.is_info"
            icon="fa-solid fa-comment-dots"
            :actionText="$t('emojiModalButton.reply_in_thread')"
            :action="toggleThread"
          />
          <EmojiModalButton
            icon="fa-solid fa-share"
            :actionText="$t('emojiModalButton.share_message')"
            :action="setShareMessageModal"
          />
          <EmojiModalButton
            icon="fa-solid fa-bookmark"
            :actionText="this.getSavedItemText(this.currMessage)"
            :action="saveMessage"
          />
          <EmojiModalButton
            icon="fa-solid fa-ellipsis-vertical"
            :actionText="$t('emojiModalButton.more_actions')"
            :action="setOptionsModal"
            :message="currMessage"
            :pinnedConversationStore="pinnedConversationStore"
            :setDeleteModal="setDeleteModal"
            :setUnpinModal="setUnpinModal"
          />
        </div>
      </span>
    </div>
    <div v-if="openEmojiModal" class="absolute right-0 z-50">
      <EmojiPicker :toggleModal="setEmojiModal" :addReaction="addReaction" />
    </div>
    <UnPinModal
      v-model:show="showUnpinModal"
      :currMessage="currMessage"
      :setUnpinModal="setUnpinModal"
    />
  </div>
  <DeleteMessageModal
    v-model:show="showDeleteModal"
    :message="currMessage"
    :setDeleteModal="setDeleteModal"
  />
  <ShareMessageModal
    v-model:show="showShareMessageModal"
    :message="currMessage"
    :toggleModal="setShareMessageModal"
  />
  <div
    class="bg-yellow-100 pl-16 p-2"
    v-if="
      messagesStore.isMessageToEdit(currMessage) &&
      (!inThread || !currMessage.is_threaded)
    "
  >
    <TextEditorVue
      :message="currMessage.content"
      :editMessage="true"
      :editMessageCallBack="editMessage"
    />
  </div>
</template>

<script>
import moment from 'moment';
import {
  NCard,
  NDivider,
  NTooltip,
  NButton,
  NText,
  NPopover,
  NAvatar,
} from 'naive-ui';
import EmojiPicker from '../../widgets/emojipicker.vue';
import EmojiModalButton from '../../widgets/emojiModalButton.vue';
import MessageSection from './MessageSection.vue';
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
import TextEditorVue from '../../components/editor/TextEditor.vue';
import { updateMessage } from '../../../modules/axios/editorapi';
import EditedAtTime from '../../widgets/editedAtTime.vue';
import downloadsModal from '../../widgets/downloadsModal/downloadsModal.vue';
import { fileDownload } from '../../../api/downloads/downloads.js';
import { useDownloadsStore } from '../../../stores/useDownloadsStore';
import ReplyAndThreadButton from '../../widgets/ReplyAndThreadButton.vue';
import ShareMessageVue from '../../widgets/sharedMessage.vue';
import DeleteMessageModal from '../../widgets/deleteMessageModal.vue';
import ShareMessageModal from '../../widgets/shareMessageModal.vue';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { storeToRefs } from 'pinia';
import UnPinModal from '../pinnedConversation/unpinModal.vue';
import VisualizeVoice from '../editor/VisualizeVoice.vue';

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
    const currentProfileStore = useCurrentProfileStore();
    const currentProfile = currentProfileStore.getCurrentProfile;
    const { savedItems } = storeToRefs(savedItemsStore);
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
      savedItems,
      currentProfile,
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
    ReplyAndThreadButton,
    ShareMessageVue,
    DeleteMessageModal,
    ShareMessageModal,
    NAvatar,
    TextEditorVue,
    EditedAtTime,
    UnPinModal,
    MessageSection,
    VisualizeVoice,
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
      showDeleteModal: false,
      showUnpinModal: false,
      currAttachment: null,
      sharedMessage: '',
      showShareMessageModal: false,
    };
  },
  beforeUnmount() {
    this.topReactions = [];
    this.displayedReactions = [];
  },
  computed: {
    messageBlock() {
      return JSON.parse(this.currMessage.content);
    },
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
      this.currMessage.reactions?.filter(reaction => {
        const isDuplicate = this.displayedReactions.includes(reaction.emoji);
        if (!isDuplicate) {
          this.displayedReactions.push(reaction.emoji);
          return true;
        }
        return false;
      });
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
    isSavedMessage() {
      const savedMessage = this.savedItems.find(
        item =>
          item.message.id === this.currMessage.id &&
          item.profile.id === this.currentProfile.id
      );
      return savedMessage ? true : false;
    },
    isDeleted() {
      return (
        JSON.parse(this.currMessage.content).blocks[0].text.text ===
        this.$t('deleteMessageModal.success')
      );
    },
    isTxtFile() {
      const fileExtension =
        this.currAttachment.attachment.filename.split('.')[1];
      return fileExtension === 'txt';
    },
    isAudioFile() {
      const fileExtension =
        this.currAttachment.attachment.filename.split('.')[1];
      return fileExtension === 'wav';
    },
    isVideoFile() {
      const fileExtension =
        this.currAttachment.attachment.filename.split('.')[1];
      return fileExtension === 'mp4';
    },
    isSharedMessage() {
      return this.currMessage.shared_message != null;
    },
  },
  methods: {
    setAttachment(attachment) {
      this.currAttachment = attachment;
    },
    editMessage(text) {
      let updatedMessage = JSON.parse(JSON.stringify(this.currMessage));
      updatedMessage.content = text;
      try {
        updateMessage(updatedMessage);
      } catch (error) {
        console.error(error);
      }
    },
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
              reaction.profile_id === this.currentProfile.id
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
          }).then(res => {
            this.savedItemsStore.addSavedItem(res.data);
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
          reaction.profile_id === this.currentProfile.id
        );
      });
    },

    downloadFile(attachment) {
      try {
        fileDownload(attachment).then(response => {
          this.downloadsStore.downloads.unshift(response.data.download);
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

    getSavedItemText(message) {
      return message.isSaved
        ? CONSTANTS.REMOVE_FROM_SAVED_ITEMS
        : CONSTANTS.ADD_TO_SAVED_ITEMS;
    },

    setDeleteModal() {
      this.showDeleteModal = !this.showDeleteModal;
    },

    setUnpinModal() {
      this.showUnpinModal = !this.showUnpinModal;
    },

    getSharedMessage() {
      this.sharedMessage = this.messagesStore.getSharedMessage(
        this.currMessage.shared_message_id
      );
    },

    setShareMessageModal() {
      this.showShareMessageModal = !this.showShareMessageModal;
    },
  },
};
</script>
<style lang="scss">
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
