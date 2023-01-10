<template>
  <n-popover style="backgroundcolor: #1e293b" trigger="hover">
    <template #trigger>
      <template v-if="actionText == $t('emojiModalButton.more_actions')">
        <n-dropdown
          class="rounded-md border border-slate-100"
          placement="bottom-start"
          size="medium"
          trigger="click"
          :options="options"
          @mouseleave="action"
          @select="handleSelect($event)"
        >
          <span
            @click="action"
            class="p-2 text-sm hover:bg-transparent px-3 rounded"
          >
            <font-awesome-icon :icon="icon" />
          </span>
        </n-dropdown>
      </template>
      <template v-else>
        <span
          @click="action(attachment?.attachment_link, attachment.attachment.filename)"
          class="p-2 text-sm hover:bg-transparent cursor-pointer rounded"
        >
          <font-awesome-icon v-if="icon" :icon="icon" />
        </span>
      </template>
    </template>
    <span>{{ actionText }}</span>
  </n-popover>
</template>

<script>
import options from './options.js';
import { NPopover, NDropdown } from 'naive-ui';
export default {
  name: 'EmojiModalButton',
  components: { NPopover, NDropdown },
  props: [
    'icon',
    'attachment',
    'actionText',
    'action'
  ],
  data() {
    return {
      options,
    };
  },
  methods: {
    handleSelect(key) {
      console.log(key)
    },
  },
};
</script>
