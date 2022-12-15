<template>
  <n-dropdown
    class="rounded-md"
    placement="bottom-end"
    size="medium"
    :show="isShowOptions"
    :options="channel_options"
    @mouseleave="toggleShow"
    :on-clickoutside="toggleShow"
  >
    <div
      oncontextmenu="return false;"
      @click="goTo(`/channels/${channel.id}`)"
      @click.right="toggleShow"
      class="flex items-center -ml-3 pl-3 hover:bg-primaryHover cursor-pointer"
    >
      <i class="fa fa-hashtag mr-2 font-bold text-white"></i>
      <p>{{ channel.name }}</p>
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown } from 'naive-ui';
import channel_options from './channel_options.js';

export default {
  name: 'ChannelItem',
  components: { NDropdown },
  props: ['goTo', 'toggleShow', 'isShowOptions', 'channel'],
  data() {
    return {
      channel_options: channel_options,
    };
  },
};
</script>
