<template>
  <div class="ml-10 mb-10 mt-5 mr-5 hover:bg-slate-50 bg-white ">
    <p class="font-black ml-5 pt-5">{{ $t('channeldetail.channelname') }}</p>
    <div class="flex ml-5">
      <i class="fas fa-hashtag mt-2 ml-1"></i>
      <p class="font-black ml-1 pt-2"> {{ this.channelname }} </p>
    </div>
  </div>
  <div class="flex flex-col ml-10 mb-10 mt-5 mr-10 hover:bg-white bg-slate-50">
    <div class="bg-white hover:bg-slate-50">
      <p class="font-black ml-5 pt-5"> {{ $t('channeldetail.topic') }} </p>
      <p class="ml-5"> Add a topic </p>
    </div>
    <div class="bg-white hover:bg-slate-50">
      <p class="font-black ml-5 pt-5"> {{ $t('channeldetail.description') }} </p>
      <p class="ml-5"> Add description </p>
    </div>
    <div class="bg-white hover:bg-slate-50">
      <p class="font-black ml-5 pt-5"> {{ $t('channeldetail.created_by') }} </p>
      <p class=" ml-5"> Irfan Nazeer </p>
    </div>
    <div class="bg-white hover:bg-slate-50">
      <p class="font-black ml-5 pt-2 pb-2"> {{ $t('channeldetail.leave') }} </p>
    </div>
    <div class="bg-white hover:bg-slate-50">
      <p class="font-black ml-5 pt-2 pb-5"> {{ $t('channeldetail.files') }} </p>
      <p class=" ml-5"> {{ $t('channeldetail.filecontent') }} </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'About',
  props: {
    channelname: String
  }
}
</script>
