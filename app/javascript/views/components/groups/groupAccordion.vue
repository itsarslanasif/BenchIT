<template>
  <div class="hover-trigger mx-2">
    <font-awesome-icon
      @click="toggleModal"
      icon="fa-plus"
      class="hover-target p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-black-400 rounded-md hover:bg-secondary"
    />
    <AccordionList class="mt-4 ml-4 text-sm text-black-400" @click="toggleList">
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer font-semibold truncate">
            {{ $t('groups.title') }}
          </span>
        </template>
        <div class="-ml-4">
          <h5
            v-for="group in groupStore.groups"
            :key="group.id"
            @click.stop="stopPropagation"
          >
            <GroupItem :group="group" :goTo="goToGroupChat" />
          </h5>
          <div
            @click="toggleModal"
            @click.stop="stopPropagation"
            class="cursor-pointer px-2 mt-1 flex rounded-md hover:bg-primaryHover"
          >
            <font-awesome-icon
              icon="fa-plus"
              class="self-center mr-2 rounded text-xs text-black-400 p-2 bg-secondary"
            />
            <p class="text-sm self-center text-black-400 truncate">
              {{ $t('groups.add_new_group') }}
            </p>
          </div>
        </div>
      </AccordionItem>
      <div v-if="showCreateGroupModal">
        <CreateGroup
          :title="$t('groups.create_group')"
          :createNewGroup="true"
          :closeModal="toggleModal"
          @click.stop="stopPropagation"
        />
      </div>
    </AccordionList>
    <div v-if="!listOpen && checkSetGroup">
      <h5 class="mx-2 cursor-pointer text-white">
        <GroupItem :group="selectedGroup" :goTo="goToGroupChat" />
      </h5>
    </div>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import { useGroupStore } from '../../../stores/useGroupStore';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import CreateGroup from './createGroupModal.vue';
import GroupItem from './groupItem.vue';
export default {
  components: {
    AccordionList,
    AccordionItem,
    GroupItem,
    CreateGroup,
  },
  data() {
    return {
      groups: [],
      selectedGroup: {},
      chat_type: '',
      listOpen: true,
      showCreateGroupModal: false,
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const groupStore = useGroupStore();
    const leftPaneStore = useLeftpaneStore();
    const messagesStore = useMessageStore();
    groupStore.index();
    return {
      groupStore,
      leftPaneStore,
      messagesStore,
    };
  },
  computed: {
    checkSetGroup() {
      return (
        this.chat_type === 'Group' &&
        this.selectedGroup.id === this.messagesStore.selectedChat.id
      );
    },
  },
  methods: {
    toggleModal() {
      this.showCreateGroupModal = !this.showCreateGroupModal;
    },
    toggleList() {
      this.listOpen = !this.listOpen;
      this.setGroup();
    },
    setGroup() {
      this.chat_type = this.messagesStore.selectedChat.conversation_type;
      if (this.chat_type === 'Group') {
        this.selectedGroup = this.messagesStore.selectedChat;
      }
    },
    goToGroupChat(chatURL, group) {
      this.messagesStore.setSelectedChat(group);
      this.$router.push(chatURL);
    },
  },
};
</script>
