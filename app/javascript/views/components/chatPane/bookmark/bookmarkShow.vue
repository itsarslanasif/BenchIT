<template>
  <div>
    <a class="BoookmarkButton" v-bind:href="'#' + data['name']">{{
      data['name']
    }}</a>
  </div>

  <div v-bind:id="data['name']" class="overlay">
    <div class="popup">
      <div>
        <h2>Bookmark</h2>
        <a class="close" href="#">×</a>
        <div class="content">
          <h5>Please enter URL :</h5>
          <input v-model="data.bookmark_URL" required />
        </div>
        <div class="content">
          <h5>Please enter name :</h5>
          <input v-model="data.name" required />
        </div>
        <div class="buttons">
          <a
            v-show="data.bookmark_URL !== '' && data.name !== ''"
            class="btn"
            @click="handleUpdate()"
            href="#"
          >
            Update
          </a>
          <a
            v-show="data.bookmark_URL !== '' && data.name !== ''"
            class="btn"
            @click="handleDelete()"
            href="#"
          >
            Delete
          </a>
          <a
            v-show="data.bookmark_URL !== '' && data.name !== ''"
            class="btn"
            @click="handleCancel()"
            href="#"
          >
            Cancel
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['data'],
  data() {
    return {
      bookmark: {
        url: '',
        name: '',
      },
    };
  },
  methods: {},
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
.btn {
  margin: 0px;
  color: rgb(0, 0, 0);
  padding: 10px;
  overflow: auto;
  border-radius: 10px;
  width: max-content;
  display: inline-block;
  margin-right: 5px;
  background-color: rgb(234, 234, 234);
  border: 1px solid rgb(212, 212, 212);
}
.btn:hover {
  background-color: rgb(78, 119, 231);
  cursor: pointer;
  color: #fff;
}
.buttons {
  display: flex;
  align-items: center;
  justify-content: center;
  overflow-x: scroll;
  overflow-y: hidden;
}
h1 {
  text-align: center;
  font-family: Tahoma, Arial, sans-serif;
  color: orange;
  margin: 100px 0;
}

.BoookmarkButton {
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
.next-btn {
  max-width: 30%;
  text-align: center;

  position: relative;
  margin-left: 240px;
  border-radius: 5px;
}

.BoookmarkButton:hover {
  background-color: rgb(78, 119, 231);
  cursor: pointer;
  color: #fff;
}

.overlay {
  position: absolute;
  top: -300px;
  bottom: 0;
  z-index: 1;
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
  font-size: 20px;
  font-style: bold;
  padding: 0px, 10px;
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
