<template>
  <div class="hover-trigger">
    <ChannelsDropDown :onlyIcon="true" />
    <AccordionList
      class="mt-5 ml-4 text-base text-slate-50"
      @click="toggleList"
    >
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer">
            {{ $t('channels.title') }}
          </span>
        </template>
        <div class="-ml-4">
          <h5
            v-for="channel in joinedChannels"
            :key="channel.id"
            class="hover:bg-primaryHover"
            @click.stop="stopPropagation"
          >
            <ChannelItem
              :channel="channel"
              :goTo="goToChannelChat"
              :toggleShow="toggleChannelOptionShow"
              :isShowOptions="showChannelOptions"
            />
          </h5>
          <div
            @click="toggleModal"
            @click.stop="stopPropagation"
            class="flex hover:bg-primaryHover cursor-pointer py-1 pl-2"
          >
            <font-awesome-icon
              icon="fa-plus"
              class="self-center mr-2 text-xs cursor-pointer text-white rounded-md p-2 bg-slate-600"
            />
            <p class="text-sm self-center text-white truncate">
              {{ $t('channels.add_new_channel') }}
            </p>
          </div>
        </div>
      </AccordionItem>
      <div v-if="showCreateChannelModal">
        <CreateChannel
          :closeModal="toggleModal"
          @click.stop="stopPropagation"
        />
      </div>
    </AccordionList>
  </div>
  <div v-if="!listOpen && checkSetChannel()" class="-ml-4">
    <h5
      class="hover:bg-primaryHover ml-4 text-base cursor-pointer text-white bg-slate-600"
    >
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
import CreateChannel from './CreateChannel.vue';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import ChannelsDropDown from '../../widgets/channelsDropDown.vue';
import { channel } from '../../../modules/setChannel/setchannel.js';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import { useRightpaneMessageStore } from '../../../stores/useRightpaneMessageStore';
export default {
  components: {
    AccordionList,
    AccordionItem,
    CreateChannel,
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
    const { joinedChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    const rightPaneMessageStore = useRightpaneMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    const rightPaneStore = useRightPaneStore();
    return {
      joinedChannels,
      leftPaneStore,
      messagesStore,
      channelStore,
      selectedChat,
      rightPaneStore,
      rightPaneMessageStore,
    };
  },
  methods: {
    toggleModal() {
      this.showCreateChannelModal = !this.showCreateChannelModal;
    },
    goToChannelChat(chatURL, channel, event) {
      if (event.ctrlKey || event.metaKey) {
        this.rightPaneMessageStore.setSelectedChat(channel);
        this.rightPaneStore.toggleChatShow(true);
      } else {
        this.messagesStore.setSelectedChat(channel);
        this.$router.push(chatURL);

        if (this.isMobileView()) {
          this.leftPaneStore.closeLeftPane();
        }
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
    checkSetChannel() {
      return (
        this.chat_type === 'Channel' &&
        this.selectedChannel.id === this.selectedChat.id
      );
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
