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
      @click="goTo(`/channels/${channel.id}`, channel)"
      @click.right="toggleShow"
      class="flex items-center -ml-4 pl-3 hover:bg-primaryHover cursor-pointer"
    >
      <div class="w-5">
        <div v-if="channel.is_private">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else>
          <font-awesome-icon icon="fa-hashtag" />
        </div>
      </div>
      <div class="px-1">{{ channel.name }}</div>
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
