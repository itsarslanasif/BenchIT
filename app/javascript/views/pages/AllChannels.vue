<template>
  <div class="screen-height">
    <div class="sticky w-full h-auto bg-blue-500 divide-y divide-slate-200">
      <div class="px-5 py-3 text-xl font-bold">
        {{ $t('channels.all_channels') }}
      </div>
      <div class="px-5 py-3">
        <n-space vertical class="w-full">
          <form @submit.prevent="handleSubmit">
            <n-input type="text" size="large" v-model:value="term" @keyup.enter="handleSubmit"
              :placeholder="$t('channels.search_by_name_or_desc')" />
          </form>
          <p class="text-small text-gray-100 font-thin">
            {{ channels?.length }} {{ $t('channels.result') }}
          </p>
        </n-space>
      </div>
    </div>
    <div class="px-5 py-3">
      <div class="hover:bg-slate-100 py-3 rounded-md flex" @mouseover="showButton = true"
        @mouseleave="showButton = false" v-for="channel in channels" :key="channel.id">
        <div class="w-5/6 px-2 py-3 font-bold relative">
          #{{ channel.name }}
        </div>
        <div class="absolute px-5 py-8 font-thin">
          {{ channel.description }}
        </div>
        <div class="py-3 px-1" @click="joinChannel(channel.id)" v-if="showButton">
          <n-button>{{ $t('actions.view') }}</n-button>
        </div>
        <div class="py-3 px-1" @click="joinChannel(channel.id)" v-if="showButton">
          <n-button type="success">{{ $t('actions.join') }}</n-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { NInput, NSpace, NButton } from 'naive-ui';
import { getChannels } from '../../api/channels/channels';
import { addMemberstoChannel } from '../../api/members/membersApi';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { storeToRefs } from 'pinia';

export default {
  name: 'AllChannels',
  components: {
    NInput,
    NSpace,
    NButton,
  },
  data() {
    return {
      channels: [],
      term: '',
      currentUser: {},
      showButton: false,
    };
  },
  setup() {
    const currentProfileStore = useCurrentProfileStore();
    const { currentProfile } = storeToRefs(currentProfileStore);

    return {
      currentProfile,
    };
  },
  methods: {
    async handleSubmit() {
      this.channels = await getChannels(this.term);
    },
    async joinChannel(channel_id) {
      const result = await addMemberstoChannel(
        [channel_id],
        this.currentProfile.id
      );
      this.$router.push(`/channels/${channel_id}`);
    },
  },
  async mounted() {
    this.channels = await getChannels();
  },
};
</script>
<style>
.screen-height {
  height: 94vh;
}
</style>
