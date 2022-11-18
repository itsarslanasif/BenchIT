<template>
  <div>
    <a class="AddBookmarkButton" href="#popup1">Add Bookmark</a>
  </div>

  <div id="popup1" class="overlay">
    <div class="popup">
      <div>
        <h2>Bookmark</h2>
        <a class="close" href="#">×</a>
        <div class="content">
          <h5>Please enter URL</h5>
          <input v-model="bookmark.url" placeholder="url" required />
        </div>
        <div class="content">
          <h5>Please enter name</h5>
          <input v-model="bookmark.name" placeholder="name" required />
        </div>
        <div class="save_button">
          <a
            v-show="bookmark.url !== '' && bookmark.name !== ''"
            class="save-btn"
            @click="handleSave()"
            href="#"
          >
            Save
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      props: ['name', 'url', 'update', 'bookmarkComponent'],
      bookmark: {
        url: '',
        name: '',
      },
    };
  },
  methods: {
    handleSave(event) {
      this.$emit('clicked', this.bookmark);
    },
  },
};
</script>

<style scoped>
.model {
  padding: 10px;
  background-color: blue;
  width: 30%;
  height: auto;
  text-align: left;
  position: fixed;
  border-radius: 10px;
}
h1 {
  text-align: center;
  font-family: Tahoma, Arial, sans-serif;
  color: orange;
  margin: 100px 0;
}
.save_button {
  display: flex;
  align-items: center;
  justify-content: center;
  overflow-x: scroll;
  overflow-y: hidden;
}

.AddBookmarkButton {
  margin: 0px;
  color: rgb(255, 255, 255);
  padding: 10px;
  overflow: auto;
  border-radius: 10px;
  width: max-content;
  display: inline-block;
  margin-right: 5px;
  background-color: rgb(4, 4, 4);
  border: 1px solid rgb(117, 116, 116);
}
.save-btn {
  margin: 0px;
  color: black;
  padding: 10px;
  overflow: auto;
  border-radius: 10px;
  width: max-content;
  display: inline-block;
  margin-right: 5px;
  background-color: rgb(234, 234, 234);
  border: 1px solid rgb(212, 212, 212);
}
.save-btn:hover {
  background-color: rgb(78, 119, 231);
  cursor: pointer;
  color: #fff;
}

.AddBookmarkButton:hover {
  background-color: rgb(78, 119, 231);
  cursor: pointer;
  color: #fff;
}

.overlay {
  position: absolute;
  z-index: 1;
  top: -300px;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.7);
  visibility: hidden;
  opacity: 0;
  transition: all 0.3s ease;
}

.overlay:target {
  visibility: visible;
  opacity: 1;
  top: 0px;
}

.popup {
  margin: 70px auto;
  padding: 20px;
  background: #fff;
  border-radius: 5px;
  width: 30%;
  position: relative;
  transition: all 5s ease-in-out;
}

.popup h2 {
  margin-top: 0;
  padding: 0px, 10px;
  font-size: 20px;
  font-style: bold;
  color: #333;
  font-family: Tahoma, Arial, sans-serif;
}
.popup h3 {
  margin-top: 0;
  color: rgb(38, 37, 37);
  font-family: Tahoma, Arial, sans-serif;
}

.popup .close {
  position: absolute;
  top: 20px;
  right: 30px;
  transition: all 200ms;
  font-size: 30px;
  font-weight: bold;
  text-decoration: none;
  color: #333;
}

.popup .close:hover {
  color: rgb(255, 0, 0);
  transform: rotate(90deg);
}

.popup .content {
  max-height: 30%;
  overflow: auto;
}
</style>
