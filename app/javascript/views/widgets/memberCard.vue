<template>
  <div
    class="flex items-center ml-1 border border-transparent rounded-md px-4 py-2 mb-1 shadow-sm hover:bg-transparent cursor-pointer"
  >
    <div>
      <img class="mr-2 w-10 h-10 rounded-md" :src="member.image_url" />
    </div>
    <div class="text-black-600">
      <p>{{ member.username }}</p>
      <p>{{ member.contact_info.email }}</p>
    </div>
    <hr />
  </div>
</template>

<script>
export default {
  props: {
    member: Object,
  },
};
</script>
