<template>
  <div class="h-screen text-center flex flex-col justify-center items-center">
    <div class="text-5xl -mt-10">
      <font-awesome-icon icon="fa-message" />
    </div>
    <div class="text-2xl">
      {{ $t('welcome.no_chat_selected') }}
    </div>
    <div>
      {{ $t('welcome.tagline') }}
    </div>
  </div>
</template>
