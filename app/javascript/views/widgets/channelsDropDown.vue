<template>
  <n-dropdown
    trigger="click"
    class="rounded-md"
    placement="bottom-end"
    size="medium"
    :options="options"
    @select="handleSelect"
  >
    <div v-if="onlyIcon">
      <font-awesome-icon
        icon="fa-plus"
        class="focus:outline-none px-2 p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
      />
    </div>
    <div v-else>
      <div class="flex hover:bg-primaryHover cursor-pointer py-1 pl-2">
        <font-awesome-icon
          icon="fa-plus"
          class="self-center mr-2 text-xs cursor-pointer text-white rounded-md p-2 bg-slate-600"
        />
        <p class="text-sm self-center text-white truncate">
          {{ $t('channels.add_new_channel') }}
        </p>
      </div>
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown } from 'naive-ui';
import { CONSTANTS } from '../../assets/constants';
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
    };
  },
  components: {
    NDropdown,
  },
  props: ['handleSelect', 'onlyIcon'],
  methods: {
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
