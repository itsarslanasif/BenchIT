<template>
  <div
    :class="{
      'flex flex-col hover:bg-transparent duration-300': hovered === channelId,
    }"
    @mouseover="onHover"
    @mouseleave="onHoverLeave"
  >
    <div
      class="p-5 flex justify-between border-b border-transparent cursor-pointer"
      @click="handleView"
    >
      <div class="flex flex-col">
        <div class="font-bold flex">
          <span>
            <font-awesome-icon icon="fa-lock" v-if="isPrivate" />
            <font-awesome-icon icon="fa-hashtag" v-else />
            {{ channelName }}
          </span>
        </div>
        <div
          class="flex flex-start items-center text-xs font-thin gap-x-2 px-3 w-flexible-3xl truncate"
        >
          <div v-if="isChannelParticipant">
            <span class="text-success font-semibold text-xs flex items-center">
              <i class="fas fa-check mr-0"></i> {{ $t('actions.joined') }}
            </span>
          </div>
          <p>
            {{ channelMemberCount }}
          </p>
          <p>
            {{ channelDescription }}
          </p>
        </div>
      </div>
      <div class="flex items-center gap-x-1 px-2">
        <div v-if="hovered === channelId" @click="handleView">
          <n-button aria-setsize="small">{{ $t('actions.view') }}</n-button>
        </div>
        <div
          v-if="hovered === channelId && isChannelParticipant"
          @click="handleLeave"
        >
          <n-button type="error">{{ $t('actions.leave') }}</n-button>
        </div>
        <div
          @click="handleJoin"
          v-if="hovered === channelId && !isChannelParticipant"
        >
          <n-button type="success">{{ $t('actions.join') }}</n-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { ref, computed } from 'vue';
import { NButton } from 'naive-ui';
import { useRouter } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';

export default {
  name: 'ChannelList',
  components: {
    NButton,
  },
  props: {
    channelName: {
      type: String,
      required: true,
    },
    channelDescription: {
      type: String,
      default: '',
    },
    channelId: {
      type: Number,
      default: '',
    },
    channelParticipants: {
      type: Array,
      default: () => [],
      validator: value => {
        return value.every(participant => {
          return participant.hasOwnProperty('id');
        });
      },
    },
    isPrivate: {
      type: Boolean,
    },
  },
  setup(props) {
    const channelName = ref(props.channelName);
    const channelDescription = ref(props.channelDescription);
    const channelId = ref(props.channelId);
    const isPrivate = ref(props.isPrivate);
    const isHovered = ref(false);
    const hovered = ref(null);
    const router = useRouter();

    const leftPaneStore = useLeftpaneStore();
    const currentProfileStore = useCurrentProfileStore();
    const channelStore = useChannelStore();
    const { currentProfile } = storeToRefs(currentProfileStore);

    const isChannelParticipant = computed(() => {
      return props.channelParticipants.some(
        participant => participant?.id == currentProfile.value.id
      );
    });

    const channelMemberCount = computed(() => {
      return `${props.channelParticipants.length} ${
        props.channelParticipants.length === 1 ? 'member' : 'members'
      } -`;
    });

    const handleJoin = async () => {
      await channelStore.joinChannel(channelId.value);
      goToChannel(channelId.value);
    };

    const handleLeave = async () => {
      await channelStore.leaveChannel(channelId.value);
    };

    const handleView = () => {
      goToChannel(channelId.value);
    };

    const goToChannel = () => {
      router.push(`/channels/${channelId.value}`);
      if (isMobileView()) {
        leftPaneStore.closeLeftPane();
      }
    };

    const isMobileView = () => {
      return window.innerWidth < 1400;
    };

    const onHover = () => {
      hovered.value = channelId.value;
    };

    const onHoverLeave = e => {
      hovered.value = null;
    };

    return {
      channelName,
      channelDescription,
      channelId,
      isPrivate,
      isHovered,
      hovered,
      isChannelParticipant,
      handleJoin,
      handleLeave,
      handleView,
      onHover,
      onHoverLeave,
      channelMemberCount,
    };
  },
};
</script>
