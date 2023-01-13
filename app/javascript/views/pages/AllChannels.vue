<template>
  <div>
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
          <p class="text-small text-gray-900 font-thin">
            {{ searchedChannels?.length }} {{ $t('channels.result') }}
          </p>
        </n-space>
      </div>
    </div>
    <div class="px-5 py-3">
      <div class="hover:bg-slate-100 py-3 rounded-md flex" @mouseover="showButton = true"
        @mouseleave="showButton = false" v-for="channel in searchedChannels" :key="channel.id">
        <div class="w-5/6 px-2 py-3 font-bold relative">
          #{{ channel.name }}
        </div>
        <div class="absolute px-5 py-8 font-thin">
          {{ channel.description }}
        </div>
        <div class="py-3 px-1" v-if="showButton">
          <n-button>{{ $t('actions.view') }}</n-button>
        </div>
        <div class="py-3 px-1" v-if="showButton && isChannelParticipant(channel.profiles)"
          @click="handleLeave(channel.id)">
          <n-button type="error">{{ $t('actions.leave') }}</n-button>
        </div>
        <div class="py-3 px-1" @click="handleJoin(channel.id)"
          v-if="showButton && !isChannelParticipant(channel.profiles)">
          <n-button type="success">{{ $t('actions.join') }}</n-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { NInput, NSpace, NButton } from 'naive-ui';
import { useChannelStore } from '../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useRouter } from 'vue-router';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';

export default {
  name: 'AllChannels',

  components: {
    NInput,
    NSpace,
    NButton,
  },

  setup() {
    const term = ref('');
    const showButton = ref(false);
    const searchedChannels = ref([]);
    const router = useRouter();

    const channelStore = useChannelStore();
    const currentProfileStore = useCurrentProfileStore();
    const { channels } = storeToRefs(channelStore);
    const { currentProfile } = storeToRefs(currentProfileStore);

    const handleSubmit = async () => {
      searchedChannels.value = await channelStore.searchChannels(term.value);
    };

    const handleJoin = async channel_id => {
      await channelStore.joinChannel(channel_id);
      goToChannel(channel_id);
    };

    const handleLeave = async (channel_id) => {
      await channelStore.leaveChannel(channel_id);
      router.push('/');
    }

    const goToChannel = channel_id => {
      router.push(`/channels/${channel_id}`);
      if (this.isMobileView) {
        this.leftPaneStore.closeLeftPane();
      }
    };

    const isChannelParticipant = channel_participants => {
      return channel_participants.some(
        participant => participant.id == currentProfile.value.id
      );
    };

    onMounted(() => {
      searchedChannels.value = channels.value;
    });

    onBeforeUnmount(() => {
      term.value = null
      showButton.value = null
      searchedChannels.value = null
    })

    return {
      term,
      showButton,
      searchedChannels,
      handleSubmit,
      handleJoin,
      handleLeave,
      goToChannel,
      isChannelParticipant,
    };
  },
};
</script>
