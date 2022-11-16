<template>
     <div class="loading" v-show="loading"  >
      <img  src="./bookmark/loading.gif"/>
    </div>
  <div v-if="chat.id">
    <div class="header">
      <div class="headerContainer">
        <img :src="chat.avatar" class="avatar" />
        <span v-if="chat.isOnline" class="avatar__badge" />
        <h4 class="name">{{ chat.name }}</h4>
        <font-awesome-icon
          v-if="chat.status == 'wfh'"
          class="icon"
          icon="fa-house-laptop"
        />
        <font-awesome-icon class="icon" icon="fa-chevron-down" />
      </div>
      <div class="phone-btn">
        <font-awesome-icon class="icon" icon="fa-phone" />
      </div>
    </div>
    <div class="header">
      <div class="headerContainer">
        <AddBookMarkBtn @clicked="onClickChild"> </AddBookMarkBtn>

        <p class="bookmarkText" v-for="bm in bookmarks" :key="bm.name">
          <bookmark :data="bm" @clicked="onClickChild"> </bookmark>

        </p>

      </div>
    </div>

  </div>
</template>

<script>

import AddBookMarkBtn from './bookmark/popup.vue'
import bookmark from './bookmark/bookmarkShow.vue'
import axios from './bookmark/axios/index.js'
export default {

  name: 'ChatHeader',
  components: {AddBookMarkBtn,bookmark,},
  props: ['chat'],
  data() {
    return {
      bookmarks:[],
      loading:true,
      user_id:1,
    }},
    mounted() {

    axios
      .get('bookmarks',)
      .then(response => {

        this.bookmarks =response.data.bookmarks;
        console.log(this.bookmarks[0])
        this.loading=false;
      })
      .catch(error => {
        this.loading=false;
        return error;
      });
  },
  methods:{
    onClickChild (value) {
      this.loading=true;
      this.bookmarks.push({name:value.name ,url:value.url})
      axios
      .post('bookmarks',
        {
          "name": value.name,
          "bookmark_URL": value.url,
          "user_id": this.user_id,
        })
      .then(response => {
       this.members = response.data.profiles;
       this.loading=false;
      })
      .catch(error => {
        this.loading=false;
        return error;

      });

      },
  }
};
</script>
<style scoped>
.header {
  align-items: center;
  border-bottom: 0.5px solid gray;
  display: flex;
  height: fit-content;
  justify-content: space-between;
  padding: 5px;
}
.loading {
  width: 80%;
  height: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;

}
.headerContainer {
  align-items: center;
  display: flex;
  overflow-x: scroll;
  overflow-y: hidden;
  text-overflow: ellipsis;
  scrollbar-color: dark;
  padding: 5px;
}
.bookmarkText {
  margin: 0px;
  padding: 10px;
}

.phone-btn {
  align-items: center;
  border-radius: 3px;
  display: flex;
  height: 30px;
  justify-content: center;
  margin: 5px;
  width: 30px;
}
.phone-btn:hover {
  background-color: rgb(138, 130, 130);
  cursor: pointer;
}
.avatar {
  background: rgb(179, 176, 176);
  border-radius: 3px;
  height: 40px;
  margin-right: 5px;
  width: fit-content;
}
.loading>img{
    width: 50px;
    height: 50px;
  }
.avatar__badge {
  background-color: rgb(54, 151, 54);
  border-radius: 50%;
  border: 2px solid white;
  height: 12px;
  margin-left: -12px;
  margin-top: 31px;
  position: relative;
  width: 12px;
}
.name {
  margin: 0 5px 0 0;
  color: black;
}
.icon {
  color: black;
}
</style>
