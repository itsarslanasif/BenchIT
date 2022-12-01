<template>
  <div class="card bg-white cursor-pointer shadow-md rounded mb-4 p-0 ml-5">
    <img
      class="Avatar rounded"
      src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
      alt="Avatar"
    />
    <h6 class="text-black ml-3 mt-3 text-sm font-bold text-left">{{ name }}</h6>
    <p class="text-sm ml-3 text-slate-400 text-left">
      {{ description }}
    </p>
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
.Avatar {
  height: 200px;
  border: 1px solid rgb(198, 196, 196);
}
</style>
