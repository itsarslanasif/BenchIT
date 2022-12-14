<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="py-5">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text" v-model="query" placeholder="Find members" @keyup="searchQuery()" />
    </div >
    <div v-if="channelDetailStore.channelMembers.length > 0" class="maxHeight overflow-auto ">
          <div v-for="member in channelDetailStore.channelMembers" :key="member.id">
            <MermberCard
              class="cursor-pointer"
              :name="member.username"
              :description="member.description"
              :img-url="member.image_url"
            />
          </div>
    </div>
    <p v-if="channelDetailStore.channelMembers.length == 0"> No matches found for {{query}} </p>
  </div>
</template>

<script>
import MermberCard from '../directMessages/memberCard.vue'
import { useChannelDetailStore } from '../../../stores/useChannelDetailStore.js';
export default {
  name: 'About',
  components:{MermberCard},
  query:'',
  mounted() {
    this.searchQuery();
  },
  setup() {
    const channelDetailStore = useChannelDetailStore();
    return { channelDetailStore };
  },
  methods: {
    async searchQuery() {
      let channel_id=window.location.pathname.split('/')[2]
      await this.channelDetailStore.getChannelMembers(
        this.query,
        channel_id
      );
    },
  }

}
</script>
<style scoped>
.maxHeight{
  max-height: 400px;
}
</style>
