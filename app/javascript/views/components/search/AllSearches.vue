<template>
  <div>
    <div class="border-b font-bold py-3 px-5 text-base">
      {{ `${$t('search.result_for')} "${searched}"` }}
    </div>
    <div class="border-b px-5 text-sm flex gap-12">
      <SearchCount
        :category="searches.messages"
        :heading="$t('search_bar.messages')"
        @click="changeEnabled($t('search_bar.messages'))"
        class="cursor-pointer py-2 px-5"
        :class="
          enabled.Messages ? 'border-b-2 border-primary font-semibold' : ''
        "
      />
      <SearchCount
        :category="searches.profiles"
        :heading="$t('search_bar.people')"
        @click="changeEnabled($t('search_bar.profiles'))"
        class="cursor-pointer py-2 px-5"
        :class="
          enabled.Profiles ? 'border-b-2 border-primary font-semibold' : ''
        "
      />
      <SearchCount
        :category="searches.channels"
        :heading="$t('search_bar.channels')"
        @click="changeEnabled($t('search_bar.channels'))"
        class="cursor-pointer py-2 px-5"
        :class="
          enabled.Channels ? 'border-b-2 border-primary font-semibold' : ''
        "
      />
    </div>
    <div v-if="searchedList">
      <SearchWrapper :list="searchedList" :listType="listType" />
    </div>
  </div>
</template>
<script>
import { storeToRefs } from 'pinia';
import { useSearchStore } from '../../../stores/useSearchStore';
import SearchCount from '../../widgets/SearchCount.vue';
import SearchWrapper from '../../widgets/SearchWrapper.vue';
export default {
  data() {
    return {
      enabled: {
        Profiles: false,
        Messages: false,
        Channels: false,
      },
      searchedList: this.searches.messages,
      listType: this.$t('search_bar.messages'),
    };
  },
  components: {
    SearchCount,
    SearchWrapper,
  },
  setup() {
    const searchStore = useSearchStore();
    const { searches, searched } = storeToRefs(searchStore);
    return {
      searches,
      searched,
    };
  },
  methods: {
    changeEnabled(key) {
      for (const k in this.enabled) {
        this.enabled[k] = k === key;
      }
      this.listType = key;
      this.searchedList = this.searches[key.toLowerCase()];
    },
  },
};
</script>
