<template>
  <div>
    <div v-if="pinnedConversationStore.isPinned(currMessage)">
      <span
        class="p-1 items-center text-black-800 text-xs flex bg-yellow-100 relative"
        >&#128204; {{ $t('pinconversation.pinnedby') }}
        {{ currMessage.pinned_by.name }}
      </span>
    </div>
    <div
      class="messageWrapper"
      :class="{
        messageContentpinned: pinnedConversationStore.isPinned(currMessage),
      }"
      @mouseover="emojiModalStatus = true"
      @mouseleave="emojiModalStatus = false"
    >
      <n-avatar
        v-show="!isSameUser"
        class="avatar"
        size="large"
        :src="currMessage.sender.avatar"
      />
      <span class="message">
        <div>
          <span class="messageInfo">
            <p v-show="!isSameUser" class="name">
              <b>{{ currMessage.sender.name }}</b>
            </p>
            <p v-bind:class="{ time: !isSameUser, 'time-on-left': isSameUser }">
              {{ isSameUser ? timeWithoutAMPM : time }}
            </p>
            <span
              v-show="isSameUser"
              class="messageContent"
              v-html="currMessage.content"
            />
          </span>
          <span
            v-show="!isSameUser"
            class="messageContent"
            v-html="currMessage.content"
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
            v-if="!currMessage.parent_message_id"
            icon="fa-solid fa-comment-dots"
            actionText="Reply in thread"
            :action="toggleThread"
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
            pinned="true"
            :handleSelect="handleSelect"
            :action="setOptionsModal"
          />
        </div>
      </span>
    </div>
  </div>
  <div v-if="openEmojiModal" class="emojiModal">
    <EmojiPicker :addReaction="addReaction" />
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
import EmojiPicker from '../../widgets/emojipicker.vue';
import EmojiModalButton from '../../widgets/emojiModalButton.vue';
import { usePinnedConversation } from '../../../stores/usePinnedConversationStore';

export default {
  name: 'MessageWrapper',
  setup() {
    const pinnedConversationStore = usePinnedConversation();
    return { pinnedConversationStore };
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
      emojiModalStatus: false,
      openEmojiModal: false,
      allReactions: [],
      showOptions: false,
    };
  },
  computed: {
    time() {
      return moment(new Date(this.currMessage.sentAt).getTime()).format(
        'h:mm A'
      );
    },
    timeWithoutAMPM() {
      return moment(new Date(this.currMessage.sentAt).getTime()).format('h:mm');
    },
    isSameUser() {
      if (!this.prevMessage) return false;
      return this.currMessage?.sender.id === this.prevMessage?.sender.id;
    },
  },
  methods: {
    addReaction(emoji) {
      this.allReactions.push(emoji);
    },
    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },
    setOptionsModal() {
      this.showOptions = !this.showOptions;
    },
    handleSelect(key) {
      if (key == 'pin-to-this-conversation') {
        if (!this.pinnedConversationStore.isPinned(this.currMessage)) {
          this.pinnedConversationStore.pinMessage(this.currMessage);
        } else {
          this.pinnedConversationStore.unPinMessage(this.currMessage);
        }
      }
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
.messageContentpinned {
  @apply bg-yellow-100;
}
.messageWrapper {
  @apply items-center flex p-3 relative;
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
  @apply mr-1;
  align-self: baseline;
  min-width: fit-content;
}

.emojiModal {
  @apply absolute right-0 z-50;
}

.emojiModalToggle {
  @apply bg-white text-black-500 p-1 rounded absolute;
  right: 5px;
  top: -15px;
}

.emoji {
  @apply bg-black-300 p-1 mr-1 rounded;
}
</style>
