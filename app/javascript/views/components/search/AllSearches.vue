<template>
  <div>
    <div class="border-b font-bold py-3 px-5 text-base">
      {{ `${$t('search.result_for')} "${searched}"` }}
    </div>
    <div class="border-b py-1 px-5 text-sm flex gap-12">
      <SearchCount :category="searches.messages" :heading="$t('search_bar.messages')"
        @click="enableMessages($t('search_bar.messages'))" class="cursor-pointer" />
      <SearchCount :category="searches.profiles" :heading="$t('search_bar.people')" />
      <SearchCount :category="searches.channels" :heading="$t('search_bar.channels')" />
    </div>
  </div>
</template>
<script>
import { storeToRefs } from 'pinia';
import { useSearchStore } from '../../../stores/useSearchStore';
import SearchCount from '../../widgets/SearchCount.vue';
export default {
  data() {
    return {
      enabled: {
        People: false,
        Messages: false,
        Channels: false,
      }
    }
  },
  components: {
    SearchCount
  },
  setup() {
    const searchStore = useSearchStore()
    const { searches, searched } = storeToRefs(searchStore)
    return {
      searches,
      searched
    }
  },
  methods: {
    enableMessages(category) {
      this.enabled[category] = true
    }
  },
}
</script>
