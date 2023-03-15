<template>
  <div v-for="block in messageBlock.blocks" :key="block">
    <div
      class="hover-trigger py-2 px-4 bg-white relative border border-black-300 shadow-sm rounded-xl m-4"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <div
        v-if="currMessage.conversationable_type === $t('conversation.channel') && reactedBy()"
        class="text-black-600 font-semibold flex m-2"
      >
        {{ reactedBy() }} {{ $t('mentions_and_reactions.reacted') }}
        <span class="ml-2 hover:underline"
          ><font-awesome-icon :icon="getIcon" />
          {{ currMessage.channel_name }}</span
        >
      </div>
      <div v-if="currMessage.conversationable_type === $t('conversation.channel') && !reactedBy()"
        class="text-black-600 font-semibold flex m-2">
        {{ mentionedBy() }} {{ $t('mentions_and_reactions.mentioned') }}
        <span class="ml-2 hover:underline"
          ><font-awesome-icon :icon="getIcon" />
          {{ currMessage.channel_name }}</span>
      </div>
      <div
        v-if="currMessage.conversationable_type === $t('conversation.profile') && reactedBy()"
        class="text-black-600 font-semibold flex m-2"
      >
        {{ reactedBy() }} {{ $t('mentions_and_reactions.reacted_by') }}
      </div>
        <div class="flex">
          <div
            class="h-10 w-10 mr-1 ml-1 rounded flex justify-center items-center"
          >
            <span v-if="getReaction()" class="text-4xl">{{ getReaction() }}</span>
            <div v-else><user-profile-modal
            :profile_id="currMessage.sender_id"
            :sender_avatar="currMessage.sender_avatar"
          /> </div>
          </div>
        <div>
          <div class="ml-1">
            <span class="items-center flex text-black-800 text-lg m-0">
              <p
                @click="showUserProfile"
                class="mr-1 text-sm hover:underline cursor-pointer"
              >
                <b>{{ currMessage.sender_name }}</b>
              </p>
              <span>
                <p
                  class="text-xs ml-1 text-black-500 hover:underline cursor-pointer"
                >
                  {{ time }}
                </p>
              </span>
            </span>
            <div class="flex mb-1">
              <MessageSection
                v-if="block.type === 'section'"
                :section="block"
              />
              <EditedAtTime
                v-if="currMessage.is_edited"
                :updated_at="currMessage.updated_at"
              />
            </div>
            <div
              v-if="!currMessage.info && currMessage.attachments"
              class="flex my-2"
            >
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
                    <div v-if="isTxtFile(attachment.attachment_link)">
                      <font-awesome-icon
                        class="w-10 h-10"
                        icon="fa-solid fa-file"
                      />
                    </div>
                    <img
                      v-else
                      :src="attachment.attachment_link"
                      class="rounded"
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
              :class="{
                'bg-blue-100 border-blue-200': isCurrentUserReaction(emoji),
              }"
              class="mt-1 inline-flex mr-1 w-12 h-7 bg-black-200 rounded-xl cursor-pointer justify-center border border-black-200 hover:border-black-500 hover:bg-white"
            >
              <n-tooltip placement="top" class="w-40" trigger="hover">
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
          <div
            class="bg-white text-black-500 p-2 border border-slate-100 rounded absolute top-0 right-0 mt-2 mr-3 shadow-xl"
            v-if="emojiModalStatus || openEmojiModal || showOptions"
          >
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
        </div>
      </div>
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
import { NTooltip, NText, NPopover } from 'naive-ui';
import EmojiPicker from '../../widgets/emojipicker.vue';
import EmojiModalButton from '../../widgets/emojiModalButton.vue';
import MessageSection from '../messages/MessageSection.vue';
import { useThreadStore } from '../../../stores/useThreadStore';
import { usePinnedConversation } from '../../../stores/UsePinnedConversationStore';
import { save } from '../../../api/save_messages/savemessage.js';
import { unsave } from '../../../api/save_messages/unsavemessage.js';
import { CONSTANTS } from '../../../assets/constants';
import { useSavedItemsStore } from '../../../stores/useSavedItemStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import UserProfileModal from '../../widgets/UserProfileModal.vue';
import {
  add_reaction,
  remove_reaction,
} from '../../../api/reactions/reaction.js';
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
import DeleteMessageModal from '../../widgets/deleteMessageModal.vue';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { storeToRefs } from 'pinia';
import UnPinModal from '../pinnedConversation/unpinModal.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { errorHandler } from '../../widgets/messageProvider';
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
    const channelStore = useChannelStore();
    const { channels } = storeToRefs(channelStore);
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
      channels,
    };
  },
  components: {
    EmojiPicker,
    EmojiModalButton,
    UserProfileModal,
    NTooltip,
    NText,
    NPopover,
    downloadsModal,
    DeleteMessageModal,
    TextEditorVue,
    EditedAtTime,
    UnPinModal,
    MessageSection,
  },
  props: {
    currMessage: {
      type: Object,
      default: undefined,
    },
  },
  data() {
    return {
      emojiModalStatus: false,
      openEmojiModal: false,
      showOptions: false,
      displayedReactions: [],
      showFileOptions: false,
      showDeleteModal: false,
      showUnpinModal: false,
    };
  },
  beforeUnmount() {
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
    displayReaction() {
      this.currMessage.reactions?.filter(reaction => {
        const isDuplicate = this.displayedReactions.includes(reaction.emoji);
        if (!isDuplicate) this.displayedReactions.push(reaction.emoji);

        return !isDuplicate;
      });
    },
    getIcon() {
      const channelDetail = this.channels.find(
        channel => channel.id === this.currMessage.conversationable_id
      );
      return `fa-${channelDetail.is_private ? 'lock' : 'hashtag'}`;
    },
  },
  methods: {
    isTxtFile(url) {
      const fileExtension = url.split('/').pop().split('.').pop();
      return fileExtension === 'txt';
    },
    editMessage(text) {
      let updatedMessage = JSON.parse(JSON.stringify(this.currMessage));
      updatedMessage.content = text;
      try {
        updateMessage(updatedMessage);
      } catch (e) {
        errorHandler(e.response.data.message);
      }
    },
    async addReaction(emoji) {
      let temp = typeof emoji === 'object' ? emoji.i : emoji;
      let emoji_id = null;
      try {
        if (
          this.currMessage.reactions.some(reaction => {
            return (
              (emoji_id = reaction.id),
              reaction.emoji === temp &&
                reaction.profile_id === this.currentProfile.id
            );
          })
        ) {
          await remove_reaction(emoji_id);
        } else {
          await add_reaction(this.currMessage.id, temp);
        }
      } catch (e) {
        errorHandler(e.response.data.message);
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
        errorHandler(e.response.data.message);
      }
    },
    countReaction(emoji) {
      const filteredReactions = this.currMessage.reactions.filter(reaction => {
        return reaction.emoji === emoji;
      });
      if (filteredReactions.length === 0) {
        this.displayedReactions = this.displayedReactions.filter(reaction => {
          return reaction != emoji;
        });
      }
      return filteredReactions.length;
    },
    getUsers(emoji, name) {
      let users = this.currMessage.reactions
        .filter(reaction => reaction.emoji === emoji)
        .map(reaction =>
          reaction.reacted_by === name ? CONSTANTS.YOU : reaction.reacted_by
        );
      const formatter = new Intl.ListFormat('en', {
        style: 'long',
        type: 'conjunction',
      });
      users = users.filter(user => user !== undefined);
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
          this.downloadsStore.downloads.unshift(response.data);
          this.downloadsStore.response = response;
          this.downloadsStore.downloadAlert = true;
        });
        this.downloadsStore.downloadAlert = false;
      } catch (e) {
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
    getReaction() {
      const otherReactions = this.currMessage.reactions.filter(
        reaction => reaction.profile_id !== this.currentProfile.id
      );
      return otherReactions?.slice(-1)[0]?.emoji;
    },
    mentionedBy() {
      return this.currMessage.sender_name
    },
    reactedBy() {
      let users = this.currMessage.reactions
        .map(reaction => reaction.reacted_by)
        .filter(user => user !== this.currentProfile.username);
      users = [...new Set(users)];
      const formatter = new Intl.ListFormat('en', {
        style: 'long',
        type: 'conjunction',
      });
      return formatter.format(users);
    },
  },
};
</script>
