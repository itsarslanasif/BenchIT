<template>
  <n-dropdown
    trigger="click"
    placement="bottom-end"
    size="medium"
    :options="options"
    @select="handleSelect"
  >
    <div v-if="onlyIcon">
      <font-awesome-icon
        icon="fa-plus"
        class="hover-target focus:outline-none px-2 p-2 float-right -ml-12 mx-3 mr-2 text-xs cursor-pointer text-center text-black-400 rounded-md hover:bg-secondary"
      />
    </div>
    <div v-else>
      <div class="flex hover:bg-primaryHover cursor-pointer py-1 pl-2">
        <font-awesome-icon
          icon="fa-plus"
          class="self-center mr-2 text-xs cursor-pointer text-black-400 rounded-md p-2 bg-slate-600"
        />
        <p class="text-sm self-center text-black-400 truncate">
          {{ $t('channels.add_new_channel') }}
        </p>
      </div>
    </div>
  </n-dropdown>
  <div v-if="showCreateChannelModal">
    <CreateChannel :close-modal="toggleModal" />
  </div>
</template>

<script>
import { NDropdown } from 'naive-ui';
import { CONSTANTS } from '../../assets/constants';
import CreateChannel from '../components/channels/CreateChannel.vue';
export default {
  data() {
    return {
      options: [
        {
          label: CONSTANTS.CREATE_CHANNEL,
          key: this.generateKey(CONSTANTS.CREATE_CHANNEL),
        },
        {
          label: CONSTANTS.BROWSE_CHANNELS,
          key: this.generateKey(CONSTANTS.BROWSE_CHANNELS),
        },
      ],
      showCreateChannelModal: false,
    };
  },
  components: {
    NDropdown,
    CreateChannel,
  },
  props: ['handleSelect', 'onlyIcon'],
  methods: {
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
    toggleModal() {
      this.showCreateChannelModal = !this.showCreateChannelModal;
    },
    handleSelect(key) {
      switch (key) {
        case 'create-a-channel':
          this.toggleModal();
          break;
        case 'browse-channels':
          this.$router.push('/browse-channels');
          break;
      }
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
