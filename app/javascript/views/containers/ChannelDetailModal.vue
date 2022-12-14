<template>
  <div class="modal cursor-pointer w-1/3 absolute z-10 inset-px bg-white rounded-xl p-2 shadow-2xl m-10">
    <p @click="detailsopen(false)" class="float-right mr-2 p-2 hover:bg-transparent rounded self-center">
      <i class="fa-solid fa-xmark"></i>
    </p>
    <p class="font-bold text-2xl pl-8">
      <i class="fas fa-hashtag mr-1"></i>{{ this.channelName }}
    </p>
    <StarUnstar :channelId = "this.channelId" />
    <div class="flex ml-4 ">
      <p @click="ChannelDetailStore.setSlectedOption('about')" :class="{ 'text-slate-800 bg-transparent': ChannelDetailStore.isAbout(),}"  class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer">
        {{ $t('channeldetail.about') }}
      </p>
      <p @click="ChannelDetailStore.setSlectedOption('members')" :class="{ 'text-slate-800 bg-transparent': ChannelDetailStore.isMembers(),}"  class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800   px-2 rounded cursor-pointer">
        {{ $t('channeldetail.members') }}
      </p>
      <p @click="ChannelDetailStore.setSlectedOption('integrations')" :class="{ 'text-slate-800 bg-transparent': ChannelDetailStore.isIntegrations(),}"  class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800   px-2 rounded cursor-pointer">
        {{ $t('channeldetail.integrations') }}
      </p>
      <p @click="ChannelDetailStore.setSlectedOption('settings')" :class="{ 'text-slate-800 bg-transparent': ChannelDetailStore.isSettings(),}"  class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800   px-2 rounded cursor-pointer">
        {{ $t('channeldetail.settings') }}
      </p>
    </div>
    <About v-if="ChannelDetailStore.isAbout()" :channelName="this.channelName" />
    <members v-if="ChannelDetailStore.isMembers()" :channelName="this.members" />
  </div>
</template>

<script>
import About from '../components/channeldetail/About.vue';
import members from '../components/channeldetail/members.vue';
import StarUnstar from '../components/channeldetail/StarUnstar.vue';
import ChannelNavVue from '../shared/_channelNav.vue';
import { useChannelDetailStore } from '../../stores/useChannelDetailStore';
export default {
  name: 'ChannelDetailModal',
  components: { About, StarUnstar,ChannelNavVue,members },
  setup() {
    const ChannelDetailStore = useChannelDetailStore();
    return { ChannelDetailStore };
  },
  props: {
    channelName: String,
    channelId: Number,
    detailsopen: Function,
  },
};
</script>
