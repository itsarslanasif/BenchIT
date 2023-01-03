<template>
  <n-modal
    v-model:show="showModal"
    class="custom-card rounded-lg w-180"
    preset="card"
    :bordered="false"
    size="huge"
  >
    <template #header>{{$t('rightpane.edit_contact_information')}}</template>
    <form @submit.prevent="handleSubmit">
      <span class="flex items-center">
        <font-awesome-icon icon="fa-lock" class="mr-2" />
        <label class="font-semibold self-center">{{$t('rightpane.email_address')}}</label>
      </span>
      <input
        v-model="email"
        type="email"
        :placeholder="$t('placeholder.email')"
        disabled
        class="border border-black-400 rounded w-150 h-12 text-black-900 mt-2 p-3 cursor-not-allowed focus:outline-none focus:bg-transparent"
      />
      <label class="flex mt-6">{{$t('rightpane.phone')}}</label>
      <input
        v-model="phone"
        type="phone-number"
        :placeholder="$t('placeholder.phone')"
        class="border border-black-400 rounded w-150 text-black-900 mt-2 h-12 p-3 focus:outline-none focus:bg-transparent"
      />
      <button
        @click="saveChanges"
        class="bg-green-700 text-white mt-8 float-right border px-4 h-9 rounded hover:bg-green-800 focus:outline-none"
      >
        {{$t('actions.save_changes')}}
      </button>
      <button
        @click="toggleModal"
        class="bg-white text-black mt-8 mr-3 float-right border px-4 h-9 rounded hover:bg-transparent focus:outline-none"
      >
        {{$t('actions.cancel')}}
      </button>
    </form>
  </n-modal>
</template>

<script>
import { NModal, NAlert } from 'naive-ui';
export default {
  components: {
    NModal,
    NAlert,
  },
  props: ['userContactInfo', 'toggleModal'],
  data() {
    return {
      email: '',
      phone: '',
    };
  },
  mounted(){
    this.setContactInfo()
  },
  beforeUnmount(){
    this.email = null
    this.phone = null
  },
  methods:{
    setContactInfo(){
      this.email = this.userContactInfo.email
      this.phone = this.userContactInfo.phone
    },
    saveChanges(){
      this.userContactInfo.phone = this.phone
      this.toggleModal()
    }
  }
};
</script>
