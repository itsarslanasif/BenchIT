<template>
  <div class="card bg-white shadow-md rounded mb-4 p-0 ml-5">
    <img
      class="Avatar"
      src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      alt="Avatar"
    />
    <h6 class="username">{{ name }}</h6>
    <p class="description">{{ description }}</p>
  </div>
</template>

<script>
export default {
  props: ['name', 'description', 'img-url'],
};
</script>

<style scoped>
.card {
  height: 300px;
  width: 200px;
}
.card:hover {
  cursor: pointer;
}

.description {
  color: rgb(96, 96, 96);
  font-size: 15px;
  text-align: left;
  margin-left: 15px;
  margin-top: -2rem;
}
.username {
  color: black;
  font-size: 15px;
  height: 20%;
  margin-top: 0.7rem;
  text-align: left;
  margin-left: 15px;
  font-weight: bolder;
  margin-bottom: 0;
}
.Avatar {
  height: 200px;
  text-align: center;
  border: 1px solid rgb(198, 196, 196);
  border-radius: 5px;
}
</style>
