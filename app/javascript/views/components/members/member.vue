<template>
  <div class="text-center rounded w-56 h-56 m-auto min-w-fit shadow-md mb-1 mx-4 mt-0">
    <div class="bg-white cursor-pointer shadow-md rounded mb-4 p-0 ml-5 m-auto">
      <img class="h-1/2 m-auto border bg-primary text-center rounded-lg"
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
