<template>
  <div>
    <a
      class="text-xs px-2 py-1 mr-2 overflow-auto rounded-md text-black-600 hover:bg-transparent w-max inline-block"
      href="#popup1"
    >
      <i class="fa-solid fa-add"></i>
      {{ $t('bookmark.add_bookmark') }}
    </a>
  </div>
  <div
    id="popup1"
    class="bg-backgroundTransparent inset-0 invisible opacity-0 transition-all ease-linear duration-300 z-10 absolute"
  >
    <div
      class="my-16 mx-auto p-5 bg-white rounded-md w-2/6 relative transition-all duration-500 ease-in-out"
    >
      <div>
        <h2>{{ $t('bookmark.title') }}</h2>
        <a
          class="absolute top-0 right-0 transition-all duration-200 text-base font-bold no-underline text-primary"
          href="#"
          >×</a
        >
        <div class="overflow-auto h-auto">
          <h5>{{ $t('bookmark.url') }}</h5>
          <input
            v-model="bookmark.url"
            :placeholder="$t('bookmark.url_placeholder')"
            required
          />
        </div>
        <div class="overflow-auto h-auto">
          <h5>{{ $t('bookmark.name') }}</h5>
          <input
            v-model="bookmark.name"
            :placeholder="$t('bookmark.name_placeholder')"
            required
          />
        </div>
        <div
          class="flex items-center justify-center overflow-x-scroll overflow-y-hidden"
        >
          <a
            v-if="bookmark.url !== '' && bookmark.name !== ''"
            class="m-0 text-black-900 p-2 rounded-md overflow-auto w-max inline-block mr-1 bg-success hover:bg-successHover cursor-pointer"
            @click="handleSave()"
            href="#"
          >
            {{ $t('actions.save') }}
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  beforeUnmount() {
    this.bookmark.url = null;
    this.bookmark.name = null;
  },
  data() {
    return {
      props: ['name', 'url', 'update', 'bookmarkComponent'],
      bookmark: {
        url: '',
        name: '',
      },
    };
  },
  methods: {
    handleSave(event) {
      this.$emit('clicked', this.bookmark);
    },
  },
};
</script>
<style scoped>
.border1 {
  border-bottom: 0.5px solid gray;
}
</style>
