<template lang="">
  <div>
    <p class="my-3">{{ markAsReadSetting.title }}</p>
    <div class="py-3">
      <p>
        <strong>{{ markAsReadSetting.viewChannel.title }}</strong>
      </p>
      <div v-for="item in markAsReadSetting.viewChannel.settings">
        <input type="radio" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <div class="py-3">
      <p>
        <strong>{{ markAsReadSetting.markEverythingAsRead.title }}</strong>
      </p>
      <div v-for="item in markAsReadSetting.markEverythingAsRead.settings">
        <input type="checkbox" />
        <label class="pl-3">{{ item.label }}</label>
      </div>
    </div>
    <div class="py-3">
      <p>
        <strong>{{ markAsReadSetting.keyboardShortcuts.title }}</strong>
      </p>
      <li class="my-2">
        {{ markAsReadSetting.keyboardShortcuts.markMessagesOfCurrentChannel }}
        <span class="bg-black-700 text-white px-2 py-1 rounded">Esc</span>
      </li>
      <li class="my-2">
        {{ markAsReadSetting.keyboardShortcuts.markMessagesAsRead }}
        <span class="bg-black-700 text-white px-2 py-1 rounded mr-1">
          Shift
        </span>
        <span class="bg-black-700 text-white px-2 py-1 rounded"> Esc </span>
      </li>
      <li class="my-2">
        {{ markAsReadSetting.keyboardShortcuts.markAsUnread }}
        <span class="bg-black-700 text-white px-2 py-1 rounded"> Alt </span>
        {{ markAsReadSetting.keyboardShortcuts.clickMessage }}
      </li>
    </div>
    <div>
      <p>
        {{ markAsReadSetting.viewFullShortcuts }}
        <span class="bg-black-700 text-white px-2 py-1 rounded mr-1">
          Ctrl
        </span>
        +
        <span class="bg-black-700 text-white px-2 py-1 rounded mr-1"> / </span>
      </p>
    </div>
  </div>
</template>
<script>
import { markAsReadSetting } from '../../../assets/settings/markAsRead';
export default {
  data() {
    return {
      markAsReadSetting,
    };
  },
};
</script>
