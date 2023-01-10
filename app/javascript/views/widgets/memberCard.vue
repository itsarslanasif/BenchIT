<template>
  <div
    class="flex place-items-center ml-1 border border-transparent rounded-md px-4 py-2 mb-1 shadow-sm hover:bg-transparent hover:font-bold"
  >
    <div>
      <img
        class="w-10 h-10 rounded-md"
        src= {{imgUrl}}
      />
    </div>
    <div class="ml-5 text-black-600 ">
      <p>{{ name }}</p>
      <p>{{ email }}</p>
    </div>
    <hr />
  </div>
</template>

<script>
export default {
  props: ['name', 'email', 'imgUrl'],
};
</script>
