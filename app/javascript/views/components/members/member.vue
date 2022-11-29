<template>
  <div class="text-center rounded w-56 h-56 m-auto min-w-fit shadow-md mb-1 mx-4 mt-0">
    <div class="card bg-white cursor-pointer shadow-md rounded mb-4 p-0 ml-5">
      <img class="Avatar h-1/2 m-auto border bg-primary text-center rounded-lg"
        src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg" alt="Avatar" />
      <h6 class="mt-1 h-1/4 text-sm">{{ name }}</h6>
      <p class="text-sm text-primary">{{ description }}</p>
    </div>
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

.Avatar {
  height: 300px;
  width: 200px;
  border: 1px solid rgb(198, 196, 196);
}
</style>
