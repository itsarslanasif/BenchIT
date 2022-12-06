<template>
  <div class="container bg-primary text-white border border-slate-600">
    <div class="grid text-slate-600 grid-cols-1 divide-y">
      <div class="p-2 text-white text-xl">Direct messages</div>
      <div class="h">
        <div class="flex p-3">
          <p>To:</p>
          <input
            type="text"
            placeholder=" @Somebody or somebody@example.com"
            ouline="none"
            class="bg-primary w-full ml-1"
          />
        </div>

        <hr />
        <div class="w-full bg-slate-800 maxHeight p-5">
          <memberCard></memberCard>
          <memberCard></memberCard>
          <memberCard></memberCard>
          <memberCard></memberCard>
        </div>
      </div>
    </div>
    <div></div>
  </div>
</template>

<script>
import memberCard from './memberCard.vue';
export default {
  components: {
    memberCard,
  },
};
</script>

<style scoped>
.maxHeight {
  height: 600px;
}
textarea:focus,
input:focus {
  outline: none;
}
</style>
