<template>
  <div class="card">
    <img class="Avatar" :src="'http://localhost:3000/' + imgUrl" alt="Avatar" />
    <h6>{{ name }}</h6>
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
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
  max-width: 200px;
  height: 200px;
  margin: auto;
  text-align: center;
}

.description {
  color: grey;
  font-size: 12px;
}
.Avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  text-align: center;
  margin: auto;
  border: 1px solid rgb(0, 0, 0);
}
</style>
