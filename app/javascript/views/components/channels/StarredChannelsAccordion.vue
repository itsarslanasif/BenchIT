<template>
  <div v-if="starChannels.length > 0" class="hover-trigger mx-2">
    <ChannelsDropDown :onlyIcon="true" />
    <AccordionList class="mt-4 ml-4 text-sm text-black-400" @click="toggleList">
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-1 cursor-pointer font-semibold truncate">
            {{ $t('channels.starred') }}
          </span>
        </template>
        <h5
          v-for="channel in starChannels"
          :key="channel.id"
          @click.stop="stopPropagation"
        >
          <div class="-ml-4">
            <ChannelItem
              :channel="channel"
              :goTo="goToChannelChat"
              :toggleShow="toggleChannelOptionShow"
              :isShowOptions="showChannelOptions"
            />
          </div>
        </h5>
      </AccordionItem>
    </AccordionList>
  </div>
  <div v-if="!listOpen && checkSetChannel">
    <h5 class="mx-2 cursor-pointer text-white">
      <ChannelItem
        :channel="selectedChannel"
        :goTo="goToChannelChat"
        :toggleShow="toggleChannelOptionShow"
        :isShowOptions="showChannelOptions"
      />
    </h5>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import ChannelsDropDown from '../../widgets/channelsDropDown.vue';
import { channel } from '../../../modules/setChannel/setchannel.js';

export default {
  components: {
    AccordionList,
    AccordionItem,
    ChannelItem,
    ChannelsDropDown,
    channel,
  },
  data() {
    return {
      channels: [],
      showChannelOptions: false,
      listOpen: true,
      showCreateChannelModal: false,
      selectedChannel: {},
      chat_type: '',
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    const channelStore = useChannelStore();
    const { starChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return {
      starChannels,
      leftPaneStore,
      messagesStore,
      channelStore,
      selectedChat,
    };
  },
  computed: {
    checkSetChannel() {
      return (
        this.chat_type === 'Channel' &&
        this.selectedChannel.id === this.selectedChat.id
      );
    },
  },
  methods: {
    toggleModal() {
      this.showCreateChannelModal = !this.showCreateChannelModal;
    },
    goToChannelChat(chatURL, channel) {
      this.messagesStore.setSelectedChat(channel);
      this.$router.push(chatURL);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
    },
    isMobileView() {
      return window.innerWidth < 1400;
    },
    toggleChannelOptionShow() {
      this.showChannelOptions = !this.showChannelOptions;
    },
    toggleList() {
      this.listOpen = !this.listOpen;
      this.setChannel();
    },
    setChannel() {
      this.chat_type = this.selectedChat.conversation_type;
      let chat_id = this.selectedChat.id;
      if (this.chat_type === 'Channel') {
        this.selectedChannel = channel(chat_id, this.channelStore);
      }
    },
    stopPropagation(event) {
      event.stopPropagation();
    },
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
