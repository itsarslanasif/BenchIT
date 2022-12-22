<template>
  <div
    class="z-10 w-full border text-white drop-shadow-2xl bg-primary py-3 rounded-md text-sm font-normal"
  >
    <p class="text-xs toDays py-1">
      {{ $t('messages_section.jump_to') }}
    </p>
    <div class="toDays hover:bg-primaryHover">
      {{ $t('messages_section.today') }}
    </div>
    <div class="toDays hover:bg-primaryHover">
      {{ $t('messages_section.yesterday') }}
    </div>
    <div class="toDays hover:bg-primaryHover">
      {{ $t('messages_section.last_week') }}
    </div>
    <div class="toDays hover:bg-primaryHover">
      {{ $t('messages_section.last_month') }}
    </div>
    <div class="toDays hover:bg-primaryHover">
      {{ $t('messages_section.the_very_beginning') }}
    </div>
    <hr class="border-primaryHover my-2" />
    <div class="toDays hover:bg-primaryHover">
      {{ $t('messages_section.jump_to_specific_date') }}
    </div>
  </div>
</template>
<script>
export default {};
</script>
<style>
.toDays {
  @apply px-5;
}
</style>
