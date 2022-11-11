<template>
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
        <p class="bookmarkText">+ Add a bookmark</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChatHeader',
  components: {},
  props: ['chat'],
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
.headerContainer {
  align-items: center;
  display: flex;
  padding: 5px;
}
.bookmarkText {
  margin: 0px;
  color: black;
}
.headerContainer:hover {
  background-color: rgb(219, 213, 213);
  border-radius: 3px;
  cursor: pointer;
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
  background-color: rgb(219, 213, 213);
  cursor: pointer;
}
.avatar {
  background: rgb(179, 176, 176);
  border-radius: 3px;
  height: 40px;
  margin-right: 5px;
  width: fit-content;
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
