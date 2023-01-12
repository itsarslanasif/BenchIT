<template>
  <div class="text-center rounded w-56 h-56 m-auto min-w-fit mb-1 mx-4 mt-10">
    <div class="bg-white cursor-pointer shadow-md rounded mb-4 p-0 ml-5 m-auto">
      <img
        class="h-1/2 m-auto border bg-primary text-center rounded"
        :src="img_url"
        alt="Avatar"
      />
      <h6 class="mt-1 h-1/4 text-sm">{{ name }}</h6>
      <p class="text-sm text-primary">{{ description }}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: ['name', 'description', 'img_url'],
};
</script>
