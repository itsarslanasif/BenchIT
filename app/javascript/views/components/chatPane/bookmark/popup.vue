<template>
<div >
  <a  class="button" href="#popup1">+bookmark</a>
</div>

<div id="popup1" class="overlay">
  <div class="popup">
  <div>
    <h2>Bookmark</h2>
    <a class="close" href="#">×</a>
    <div class="content">
        <h5>Please enter URL :</h5>
        <input v-model="bookmark.url" type="email" placeholder="url" required/>
    </div>
    <div class="content">
        <h5>Please enter name :</h5>
        <input v-model="bookmark.name" placeholder="name" required/>
    </div>
    <a v-show="bookmark.name!=='' &&  validURL(bookmark.url)" class="  save-btn" @click="handleSave()"  href="#" > Save </a>
  </div>
  </div>

</div>
</template>

<script>
export default {
  data() {
    return {
      props: ['name', 'url', 'update','bookmarkComponent'],
      bookmark:{
         url: '',
         name:'',
      },
    }},
    methods :{
      handleSave(event) {
        this.$emit('clicked',this.bookmark)
        },
      validURL(str) {
        var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
        '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
      return !!pattern.test(str);
      },
    },
};
</script>

<style scoped>
.model{
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


.button {
  margin: 0px;
  text-decoration: none;
  color: #fff;
  padding: 10px;
  border-radius: 10px;
  margin-right: 5px;
  background-color: rgb(3, 3, 2);
  border: 1px solid rgb(212, 212, 212);
}
.save-btn{
 max-width: 30%;
 text-align: center;

 position: relative;
 margin-left: 240px;
 border-radius: 5px;
}

.button:hover {
  background-color: rgb(78, 119, 231);
  cursor: pointer;
  color: #fff;
}

.overlay {
  position: absolute;
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
  top:0px;
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
  color: #333;
  font-family: Tahoma, Arial, sans-serif;
}
.popup h3 {
  margin-top: 0;
  color: rgb(38, 37, 37) ;
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
