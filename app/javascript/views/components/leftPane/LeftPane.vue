<template>
  <WorkspaceDropdown />
  <div class="flex flex-col h-full overflow-y-auto overflow-x-hidden pb-6">
    <div class="m-2">
      <IconElement
        icon="fa-regular fa-comment"
        :name="$t('sidebar.threads')"
        @click="goTo('/threads')"
      />
      <IconElement
        icon="fa-regular fa-comments"
        :name="$t('sidebar.direct_messages')"
        @click="goTo('/direct_messages')"
      />
      <IconElement icon="fa-at" :name="$t('sidebar.mentions_and_reactions')" />
      <IconElement icon="fa-paper-plane" :name="$t('sidebar.draft_and_sent')" />
      <IconElement
        icon="fa-regular fa-address-book"
        :name="$t('sidebar.people_and_user_group')"
      />
      <IconElement
        icon="fa-regular fa-bookmark"
        :name="$t('sidebar.saved_items')"
        @click="goTo(`/savemessages`)"
      />
      <IconElement
        icon="fa-hashtag"
        :name="$t('sidebar.all_channels')"
        @click="goTo(`/browse-channels`)"
      />
      <IconElement
        icon="fa-ellipsis-vertical"
        :name="$t('sidebar.more')"
        @click="toggleShow()"
      />
      <n-dropdown
        class="rounded-md border ml-4 border-slate-100"
        placement="bottom-end"
        size="small"
        :show="showMore"
        :options="moreOptions"
        :render-icon="renderDropdownIcon"
        @select="handleSelect($event)"
        :on-clickoutside="toggleShow"
      >
        <p />
      </n-dropdown>
    </div>
    <hr class="text-dark" />
    <div>
      <StarredChannelsAccordion />
      <ChannelsAccordion />
      <DirectMessageAccordian />
      <groupAccordion />
    </div>
  </div>
</template>

<script>
import ChannelsAccordion from '../channels/ChannelsAccordion.vue';
import IconElement from '../../widgets/IconElement.vue';
import DirectMessageAccordian from '../directMessages/directMessagesAccordion.vue';
import WorkspaceDropdown from '../../widgets/workspaceDropdown/WorkspaceDropdown.vue';
import StarredChannelsAccordion from '../channels/StarredChannelsAccordion.vue';
import { CONSTANTS } from '../../../assets/constants';
import { h, ref, computed } from 'vue';
import { NDropdown, NTooltip } from 'naive-ui';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import groupAccordion from '../groups/groupAccordion.vue';
import {
  faStream,
  faComments,
  faAt,
  faPaperPlane,
  faAddressBook,
  faBookmark,
  faHashtag,
  faFile,
  faNetworkWired,
  faShapes,
} from '@fortawesome/free-solid-svg-icons';
import { useRouter } from 'vue-router';
import { useDraftAndSentMessagesStore } from '../../../stores/useDraftAndSentMessagesStore';

const renderDropdownIcon = icon => {
  return () => {
    return h(FontAwesomeIcon, { icon });
  };
};
export default {
  components: {
    ChannelsAccordion,
    IconElement,
    DirectMessageAccordian,
    WorkspaceDropdown,
    StarredChannelsAccordion,
    NDropdown,
    NTooltip,
    groupAccordion,
  },
  setup() {
    const router = useRouter();
    let showMore = ref(false);
    const draftAndSentMessagesStore = useDraftAndSentMessagesStore();
    const { draftMessages } = draftAndSentMessagesStore;

    const totalDraftMessages = computed(() => {
      return draftMessages.length;
    });
    const draftsExist = computed(() => {
      draftMessages.length >= 1;
    });

    const generateKey = label => {
      return label.toLowerCase().replace(/ /g, '-');
    };
    const moreOptions = [
      {
        label: CONSTANTS.UNREADS,
        key: generateKey(CONSTANTS.UNREADS),
        icon: renderDropdownIcon(faStream),
      },
      {
        label: CONSTANTS.DIRECT_MESSAGES,
        key: generateKey(CONSTANTS.DIRECT_MESSAGES),
        icon: renderDropdownIcon(faComments),
      },
      {
        label: CONSTANTS.MENTIONS_AND_REACTIONS,
        key: generateKey(CONSTANTS.MENTIONS_AND_REACTIONS),
        icon: renderDropdownIcon(faAt),
      },
      {
        label: CONSTANTS.DRAFT_AND_SEND,
        // render: renderDraftAndSend,
        key: generateKey(CONSTANTS.DRAFT_AND_SEND),
        icon: renderDropdownIcon(faPaperPlane),
      },
      {
        label: CONSTANTS.SAVED_ITEMS,
        key: generateKey(CONSTANTS.SAVED_ITEMS),
        icon: renderDropdownIcon(faBookmark),
      },
      {
        type: 'divider',
        key: 'd1',
      },
      {
        label: CONSTANTS.BENCHIT_CONNECT,
        key: generateKey(CONSTANTS.BENCHIT_CONNECT),
        icon: renderDropdownIcon(faNetworkWired),
      },
      {
        label: CONSTANTS.ALL_CHANNELS,
        key: generateKey(CONSTANTS.ALL_CHANNELS),
        icon: renderDropdownIcon(faHashtag),
      },
      {
        label: CONSTANTS.FILES,
        key: generateKey(CONSTANTS.FILES),
        icon: renderDropdownIcon(faFile),
      },
      {
        label: CONSTANTS.PEOPLE_AND_USER_GROUPS,
        key: generateKey(CONSTANTS.PEOPLE_AND_USER_GROUPS),
        icon: renderDropdownIcon(faAddressBook),
      },
      {
        label: CONSTANTS.APPS,
        key: generateKey(CONSTANTS.APPS),
        icon: renderDropdownIcon(faShapes),
      },
      {
        type: 'divider',
        key: 'd2',
      },
      {
        label: CONSTANTS.CUSTOMIZE_MORE,
        key: generateKey(CONSTANTS.CUSTOMIZE_MORE),
      },
    ];
    const goTo = url => {
      router.push(url);
    };
    const toggleShow = () => {
      showMore.value = !showMore.value;
    };
    const handleSelect = key => {
      switch (key) {
        case generateKey(CONSTANTS.DIRECT_MESSAGES):
          goTo('/direct_messages');
          break;
        case generateKey(CONSTANTS.DRAFT_AND_SEND):
          goTo('/drafts_sent_messages');
          break;
        case generateKey(CONSTANTS.SAVED_ITEMS):
          goTo('/savemessages');
          break;
        case generateKey(CONSTANTS.ALL_CHANNELS):
          goTo('browse-channels');
          break;
        case generateKey(CONSTANTS.PEOPLE_AND_USER_GROUPS):
          goTo('members');
          break;
        default:
          break;
      }
    };
    return {
      moreOptions,
      toggleShow,
      goTo,
      showMore,
      handleSelect,
      totalDraftMessages,
      draftsExist,
    };
  },
};
</script>
<style>
.container {
  height: 88vh;
}
</style>
