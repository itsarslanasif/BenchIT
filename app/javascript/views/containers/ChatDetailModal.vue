<template>
  <div
    v-click-outside="toggleModal"
    class="w-150 absolute z-10 inset-px bg-white rounded-xl p-2 shadow-xl border border-black-300"
  >
    <div class="flex gap-1 self-center items-center px-3 mt-2 mr-1">
      <font-awesome-icon
        v-if="!isProfile && chat.is_private && !isGroup"
        icon="fa-lock"
      />
      <font-awesome-icon
        v-if="!isProfile && !chat.is_private && !isGroup"
        icon="fa-hashtag"
      />
      <img
        v-if="isProfile"
        :src="chat.image_url"
        class="w-20 h-20 rounded mr-2 bg-slate-50"
      />
      <div class="flex flex-col">
        <span class="font-bold text-lg">
          {{ isProfile ? chat.username : chat.name }}
        </span>
        <span>
          {{ isProfile ? chat.description : '' }}
        </span>
      </div>
    </div>
    <div class="flex gap-2 my-5">
      <StarUnstar :chat="chat" />
      <span
        v-if="isProfile"
        class="flex gap-1 border items-center rounded px-3 h-8 cursor-pointer hover:bg-transparent"
      >
        <i class="fa-regular fa-bell" />
        <p class="text-sm">{{ $t('chat_detail.mute') }}</p>
      </span>
      <span
        v-if="isProfile"
        class="flex gap-1 border items-center rounded px-3 h-8 cursor-pointer hover:bg-transparent"
      >
        <i class="fa-solid fa-phone" />
        <p class="text-sm">{{ $t('chat_detail.start_a_call') }}</p>
      </span>
    </div>
    <div class="flex ml-4">
      <p
        @click="ChannelDetailStore.setSlectedOption('about')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isAbout(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.about') }}
      </p>
      <p
        v-if="!isProfile"
        @click="ChannelDetailStore.setSlectedOption('members')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isMembers(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.members') }}
      </p>
      <p
        @click="ChannelDetailStore.setSlectedOption('integrations')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isIntegrations(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.integrations') }}
      </p>
      <p
        v-if="!isProfile"
        @click="ChannelDetailStore.setSlectedOption('settings')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isSettings(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('chat_detail.settings') }}
      </p>
    </div>
    <About
      v-if="ChannelDetailStore.isAbout()"
      :chat="chat"
      :toggleModal="toggleModal"
    />

    <members
      v-if="
        ChannelDetailStore.isMembers() &&
        messagesStore.selectedChat.conversation_type === 'Channel'
      "
    />
    <GroupMembers
      v-if="messagesStore.selectedChat.conversation_type === 'Group'"
    />
  </div>
</template>

<script>
import About from '../components/channeldetail/About.vue';
import Members from '../components/channeldetail/members.vue';
import StarUnstar from '../components/channeldetail/StarUnstar.vue';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
import vClickOutside from 'click-outside-vue3';
import { useMessageStore } from '../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';
import { NAvatar } from 'naive-ui';
import GroupMembers from '../components/groups/groupMembers.vue';
export default {
  components: { About, StarUnstar, Members, NAvatar, GroupMembers },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const messagesStore = useMessageStore();
    return { ChannelDetailStore, messagesStore };
  },
  props: {
    toggleModal: Function,
    chat: Object,
  },
  computed: {
    isProfile() {
      return this.chat.conversation_type === 'Profile';
    },
    isGroup() {
      return this.chat.conversation_type === 'Group';
    },
  },
};
</script>
