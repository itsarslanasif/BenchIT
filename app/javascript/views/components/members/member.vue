<template>
  <div class="card">
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
  box-shadow: 0 4px 8px 0 rgba(84, 78, 78, 0.2);
  width: 250px;
  height: 250px;
  margin: auto;
  text-align: center;
  margin: 0rem 1rem;
  border-radius: 4px;
  min-width: 250px;
  margin-bottom: 1rem;
}

.description {
  color: grey;
  font-size: 12px;
}
.username {
  font-size: 12px;
  height: 20%;
  margin-top: 0.3rem;
}
.Avatar {
  height: 50%;
  border-radius: 50%;
  text-align: center;
  margin: auto;
  border: 1px solid rgb(0, 0, 0);
}
</style>
