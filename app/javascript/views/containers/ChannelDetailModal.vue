<template>
  <div
    v-click-outside="closeModel"
    class="modal cursor-pointer w-1/3 absolute z-10 inset-px bg-white rounded-xl p-2 shadow-2xl m-10"
  >
    <p
      @click="detailsopen(false)"
      class="float-right mr-2 p-2 hover:bg-transparent rounded self-center"
    >
      <i class="fa-solid fa-xmark"></i>
    </p>
    <p class="font-bold text-2xl pl-8">
      <i class="fas fa-hashtag mr-1"></i>{{ conversationInfo.name }}
    </p>
    <StarUnstar :channelId="conversationInfo?.id" />
    <div class="flex ml-4">
      <p
        @click="conversationInfoStore.setSlectedOption('about')"
        :class="{
          'text-slate-800 bg-transparent': conversationInfoStore.isAbout(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.about') }}
      </p>
      <p
        @click="conversationInfoStore.setSlectedOption('members')"
        :class="{
          'text-slate-800 bg-transparent': conversationInfoStore.isMembers(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.members') }}
      </p>
      <p
        @click="conversationInfoStore.setSlectedOption('integrations')"
        :class="{
          'text-slate-800 bg-transparent': conversationInfoStore.isIntegrations(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.integrations') }}
      </p>
      <p
        @click="conversationInfoStore.setSlectedOption('settings')"
        :class="{
          'text-slate-800 bg-transparent': conversationInfoStore.isSettings(),
        }"
        class="ml-3 hover:bg-transparent text-slate-200 hover:text-slate-800 px-2 rounded cursor-pointer"
      >
        {{ $t('channeldetail.settings') }}
      </p>
    </div>
    <About
      v-if="conversationInfoStore.isAbout()"
    />
    <members v-if="conversationInfoStore.isMembers()" />
  </div> 
</template>

<script>
import About from '../components/channeldetail/About.vue';
import Members from '../components/channeldetail/members.vue';
import StarUnstar from '../components/channeldetail/StarUnstar.vue';
import { useConversationInfoStore } from '../../stores/useConversationInfoStore';
import { storeToRefs } from 'pinia';
import vClickOutside from 'click-outside-vue3';

export default {
  name: 'ChannelDetailModal',
  components: { About, StarUnstar, Members },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  setup() {
    const conversationInfoStore = useConversationInfoStore()
    const {conversationInfo} = storeToRefs(conversationInfoStore)

    return { 
      conversationInfo,
      conversationInfoStore
    };
  },
  props: {
    detailsopen: Function,
  },
  methods: {
    closeModel() {
      this.detailsopen(false);
    },
  },
};
</script>
