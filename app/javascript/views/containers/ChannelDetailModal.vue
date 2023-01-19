<template>
  <div
    v-click-outside="closeModal"
    class="w-150 absolute z-10 inset-px bg-white rounded-xl p-2 shadow-xl border border-black-300"
  >
    <div class="self-center px-3 mt-2 mr-1 text-base ml-4 font-bold">
      <font-awesome-icon v-if="selectedChat.is_private" icon="fa-lock" />
      <font-awesome-icon v-else icon="fa-hashtag" />
      {{ selectedChat.name }}
    </div>
    <StarUnstar :channelId="selectedChat.id" />
    <div class="flex ml-4">
      <p
        @click="ChannelDetailStore.setSlectedOption('about')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isAbout(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.about') }}
      </p>
      <p
        @click="ChannelDetailStore.setSlectedOption('members')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isMembers(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.members') }}
      </p>
      <p
        @click="ChannelDetailStore.setSlectedOption('integrations')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isIntegrations(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.integrations') }}
      </p>
      <p
        @click="ChannelDetailStore.setSlectedOption('settings')"
        :class="{
          'text-slate-800 bg-transparent': ChannelDetailStore.isSettings(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.settings') }}
      </p>
    </div>
    <About v-if="ChannelDetailStore.isAbout()" />
    <members v-if="ChannelDetailStore.isMembers()" />
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
export default {
  name: 'ChannelDetailModal',
  components: { About, StarUnstar, Members },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  mounted() {
    console.log(this.currentChannel)
  },
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { ChannelDetailStore, selectedChat };
  },
  props: {
    detailsopen: Function,
  },
  methods: {
    closeModal() {
      this.detailsopen(false);
    },
  },
};
</script>
