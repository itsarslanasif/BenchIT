<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="py-5">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text" v-model="query" placeholder="Find members" @keyup.enter="searchQuery()" />
    </div >
    <div class="bg-slate-800 maxHeight overflow-auto ">
          <div class="" v-for="member in members" :key="member.id">
            <MermberCard
              class="cursor-pointer"
              :name="member.username"
              :description="member.description"
              :img-url="member.image_url"
            />
          </div>
    </div>
  </div>
</template>

<script>
import MermberCard from '../directMessages/memberCard.vue'
export default {
  name: 'About',
  components:{MermberCard},
  data() {
    return {
      members:[
        {username:"asad",description:"ase",img_url:''},
        {username:"asad",description:"ase",img_url:''},
        {username:"asad",description:"ase",img_url:''},
        {username:"asad",description:"ase",img_url:''},
        {username:"asad",description:"ase",img_url:''},
     
      ]
    }
  },

  props: {
    channelname: String
  }
}
</script>
<style scoped>
.maxHeight{
  max-height: 400px;
}
</style>
