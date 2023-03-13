<template>
  <div class="hover-trigger" @click="toggleModal">
    <font-awesome-icon
      icon="fa-plus"
      class="hover-target p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
    />
    <AccordionList class="mt-5 ml-4 text-base text-slate-50">
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer">
            {{ $t('groups.title') }}
          </span>
        </template>
        <div class="-ml-4">
          <h5
            v-for="group in groupStore.groups"
            :key="group.id"
            class="hover:bg-primaryHover"
            @click.stop="stopPropagation"
          >
            <GroupItem :group="group" :goTo="goToGroupChat" />
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
  methods: {
    toggleModal() {
      this.showCreateGroupModal = !this.showCreateGroupModal;
    },
    toggleList() {
      this.listOpen = !this.listOpen;
    },
    goToGroupChat(chatURL, group) {
      this.messagesStore.setSelectedChat(group);
      this.$router.push(chatURL);
    },
  },
};
</script>
