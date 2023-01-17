<template>
  <div>
    <div class="sticky w-full h-auto bg-blue-500 divide-y divide-slate-200">
      <div class="px-5 py-3 text-xl font-bold">
        {{ $t('channels.all_channels') }}
      </div>
      <div class="px-5 py-3">
        <n-space vertical class="w-full">
          <form @submit.prevent="handleSubmit">
            <n-input
              type="text"
              size="large"
              v-model:value="term"
              @keyup.enter="handleSubmit"
              :placeholder="$t('channels.search_by_name_or_desc')"
            />
          </form>
          <p v-if="searchedChannels" class="text-sm text-black-500">
            {{ searchedChannels.length }} {{ $t('channels.title') }}
          </p>
        </n-space>
      </div>
    </div>

    <div class="px-6 flex flex-col">
      <div
        class="hover-trigger flex justify-between hover:bg-transparent cursor-pointer py-4 px-2 border-transparent border border-t-1 border-b-0 border-r-0 border-l-0"
        v-for="channel in searchedChannels"
        :key="channel.id"
      >
        <span class="flex flex-col">
          <span class="flex text-black-700">
            <font-awesome-icon
              v-if="channel.is_private"
              class="text-xs self-center mr-1"
              icon="fa-lock"
            />
            <font-awesome-icon
              v-else
              class="text-xs self-center mr-1"
              icon="fa-hashtag"
            />
            <p class="text-base font-semibold self-center">
              {{ channel.name }}
            </p>
          </span>
          <span class="flex">
            <p class="text-black-400 mr-1">
              {{ channel.profiles.length }}
              {{
                hasOneMember(channel.profiles)
                  ? $t('members.member')
                  : $t('members.members')
              }}
            </p>
            <p class="text-black-400 font-bold">
              {{ $t('channels.dot') }}
            </p>
            <p class="text-black-400 ml-1">
              {{ channel.description }}
            </p>
          </span>
        </span>

        <span class="hover-target self-center">
          <button
            class="py-1 rounded mx-1 font-medium hover:shadow-inner focus:outline-none bg-white border-black-400 px-4 border"
            @click="
              isChannelParticipant(channel.profiles)
                ? goToChannel(channel.id)
                : null
            "
          >
            {{ $t('actions.view') }}
          </button>
          <button
            class="py-1 rounded mx-1 font-medium hover:shadow-inner focus:outline-none bg-danger hover:bg-dangerHover text-white border-black-400 px-4 border"
            v-if="isChannelParticipant(channel.profiles)"
            @click="handleLeave(channel.id)"
          >
            {{ $t('actions.leave') }}
          </button>
          <button
            class="py-1 rounded mx-1 font-medium hover:shadow-inner focus:outline-none bg-success hover:bg-successHover text-white border-black-400 px-4 border"
            @click="handleJoin(channel.id)"
            v-if="!isChannelParticipant(channel.profiles)"
          >
            {{ $t('actions.join') }}
          </button>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { NInput, NSpace, NButton } from 'naive-ui';
import { useChannelStore } from '../../stores/useChannelStore';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
import { storeToRefs } from 'pinia';
import { useRouter } from 'vue-router';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';

export default {
  components: {
    NInput,
    NSpace,
    NButton,
  },
  setup() {
    const term = ref('');
    const searchedChannels = ref([]);
    const router = useRouter();
    const channelStore = useChannelStore();
    const leftPaneStore = useLeftpaneStore();
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
    const handleLeave = async channel_id => {
      await channelStore.leaveChannel(channel_id);
      router.push('/');
    };
    const goToChannel = channel_id => {
      router.push(`/channels/${channel_id}`);
      if (isMobileView()) {
        leftPaneStore.closeLeftPane();
      }
    };
    const isMobileView = () => {
      return window.innerWidth < 1400;
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
      term.value = null;
      searchedChannels.value = null;
    });
    const hasOneMember = channel_members => {
      return channel_members.length === 1;
    };
    return {
      term,
      searchedChannels,
      handleSubmit,
      handleJoin,
      handleLeave,
      goToChannel,
      isChannelParticipant,
      hasOneMember,
    };
  },
};
</script>
<style scoped>
.hover-trigger .hover-target {
  display: none;
}
.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
