<template>
  <div
    v-click-outside="toggleModal"
    class="w-150 absolute z-10 inset-px bg-white rounded-xl p-2 shadow-xl border border-black-300"
  >
    <div
      class="flex justify-between gap-1 self-center items-center px-3 mt-2 mr-1"
    >
      <div class="flex self-center items-center px-3 mt-2">
        <span class="mr-1">
          <font-awesome-icon
            v-if="!isProfile && chat.is_private && !isGroup"
            icon="fa-lock"
          />
          <font-awesome-icon
            v-if="!isProfile && !chat.is_private && !isGroup"
            icon="fa-hashtag"
          />
        </span>
        <img
          v-if="isProfile"
          :src="chat.image_url"
          class="w-20 h-20 rounded mr-2 bg-slate-50"
        />
        <div class="flex flex-col">
          <span v-if="!isGroup" class="font-bold text-lg">
            {{
              isProfile
                ? messagesStore.selectedChat.username
                : messagesStore.selectedChat.name
            }}
          </span>
          <span v-if="isGroup" class="font-bold text-lg">
            {{ messagesStore.selectedChat.name }}
          </span>
          <span>
            {{ isProfile ? chat.description : '' }}
          </span>
        </div>
      </div>
      <font-awesome-icon
        @click="toggleModal"
        class="hover:text-primary text-black-500 w-5 h-5"
        icon="fa-solid fa-xmark"
      />
    </div>

    <div class="flex gap-x-1 ml-2 my-5">
      <StarUnstar :chat="chat" />
      <span
        v-if="isProfile && !isOwnProfile"
        class="flex gap-1 border items-center rounded px-3 h-8 cursor-pointer hover:bg-transparent"
      >
        <i class="fa-regular fa-bell" />
        <p class="text-sm">{{ $t('chat_detail.mute') }}</p>
      </span>
      <span
        v-if="isProfile && !isOwnProfile"
        class="flex gap-1 border items-center rounded px-3 h-8 cursor-pointer hover:bg-transparent"
      >
        <i class="fa-solid fa-phone" />
        <p class="text-sm">{{ $t('chat_detail.start_a_call') }}</p>
      </span>
    </div>
    <div class="flex ml-4 overflow-auto">
      <p
        @click="channelDetailStore.setSelectedOption('about')"
        :class="{
          'text-slate-800 bg-transparent': channelDetailStore.isAbout(),
        }"
        class="ml-3 hover:bg-transparent hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.about') }}
      </p>
      <p
        v-if="!isProfile"
        @click="channelDetailStore.setSelectedOption('members')"
        :class="{
          'text-slate-800 bg-transparent': channelDetailStore.isMembers(),
        }"
        class="ml-3 hover:bg-transparent hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.members') }}
      </p>
      <p
        @click="channelDetailStore.setSelectedOption('integrations')"
        :class="{
          'bg-transparent': channelDetailStore.isIntegrations(),
        }"
        class="ml-3 hover:bg-transparent hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.integrations') }}
      </p>
      <p
        v-if="!isProfile"
        @click="channelDetailStore.setSelectedOption('settings')"
        :class="{
          'bg-transparent': channelDetailStore.isSettings(),
        }"
        class="ml-3 hover:bg-transparent hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.settings') }}
      </p>
    </div>
    <About
      v-if="channelDetailStore.isAbout()"
      :chat="chat"
      :toggleModal="toggleModal"
    />
    <members
      :toggleModal="toggleModal"
      v-if="!isProfile && channelDetailStore.isMembers() && !isGroup"
    />
    <GroupMembers
      v-if="
        channelDetailStore.isMembers() &&
        messagesStore.selectedChat.conversation_type === 'Group'
      "
    />
  </div>
</template>

<script>
import About from '../components/channeldetail/About.vue';
import Members from '../components/channeldetail/members.vue';
import StarUnstar from '../components/channeldetail/StarUnstar.vue';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import vClickOutside from 'click-outside-vue3';
import { NAvatar } from 'naive-ui';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import GroupMembers from '../components/groups/groupMembers.vue';
import { useMessageStore } from '../../stores/useMessagesStore';
export default {
  components: { About, StarUnstar, Members, NAvatar, GroupMembers },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  setup() {
    const channelDetailStore = useChannelDetailStore();
    const currentProfileStore = useCurrentProfileStore();
    const messagesStore = useMessageStore();
    return { currentProfileStore, channelDetailStore, messagesStore };
  },
  props: {
    toggleModal: Function,
    chat: Object,
  },
  beforeUnmount() {
    this.channelDetailStore.setSelectedOption('about');
  },
  computed: {
    isProfile() {
      return this.chat.conversation_type === 'Profile';
    },
    isOwnProfile() {
      return this.currentProfileStore.currentProfile.id === this.chat.id;
    },
    isGroup() {
      return this.chat.conversation_type === 'Group';
    },
  },
};
</script>
