<template>
  <div class="hover-trigger">
    <!-- <ChannelsDropDown :onlyIcon="true" /> -->
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
            <GroupItem :group="group" />
            <!-- <ChannelItem
              :channel="channel"
              :goTo="goToChannelChat"
              :toggleShow="toggleChannelOptionShow"
              :isShowOptions="showChannelOptions"
            /> -->
          </h5>
          <!-- <div
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
          </div> -->
        </div>
      </AccordionItem>
      <!-- <div v-if="showCreateChannelModal">
        <CreateChannel
          :closeModal="toggleModal"
          @click.stop="stopPropagation"
        />
      </div> -->
    </AccordionList>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import { useGroupStore } from '../../../stores/useGroupStore';
import GroupItem from './groupItem.vue';
export default {
  components: {
    AccordionList,
    AccordionItem,
    GroupItem,
  },
  data() {
    return {
      groups: [],
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const groupStore = useGroupStore();
    groupStore.index();
    console.log(groupStore.groups);
    return {
      groupStore,
    };
  },
  methods: {},
};
</script>
<style scoped></style>
