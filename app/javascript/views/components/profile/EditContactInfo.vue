<template>
  <div>
    <!--Overlay-->
    <div
      class="bg-black-900 bg-opacity-50 z-50 inset-0 absolute"
      v-if="modalShow"
    >
      <!-- Modal -->
      <div class="fixed inset-0 flex justify-center items-center z-10">
        <div
          class="bg-white rounded-lg overflow-hidden shadow-2xl w-2/3 sm:w-1/2 lg:w-1/3 xl:w-1/4 max-h-screen"
        >
          <!-- Header -->
          <div class="flex items-center justify-between py-4 px-6 bg-gray-100">
            <div class="text-xl font-medium text-gray-800">
              {{ $t('profile.edit_contact_information') }}
            </div>
            <button
              class="text-gray-400 hover:text-gray-500 focus:outline-none"
              @click="closeModal()"
            >
              <i class="fas fa-times"></i>
            </button>
          </div>

          <!-- Body -->
          <form @submit.prevent="handleSubmit" class="p-4">
            <n-space vertical>
              <label class="font-medium">{{ $t('profile.email') }}</label>
              <n-input v-model:value="profileEmail" type="text" readonly/>
              <label class="font-medium">{{ $t('profile.phone') }}</label>
              <n-input v-model:value="profilePhone" type="text" :placeholder="$t('profile.edit_phone_placeholder')" :allow-input="onlyAllowNumber"/>
            </n-space>

            <!-- Footer -->
            <div class="flex items-center justify-end py-4 px-6 bg-gray-100">
              <button class="btn btn-blue-400 btn-lg px-1" @click="closeModal">
                {{ $t('actions.cancel') }}
              </button>
              <button class="btn btn-blue-400 btn-lg px-1" type="submit">
                {{ $t('actions.save') }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <!-- Trigger -->
    <button class="btn btn-blue-400" @click="openModal">
      Edit Contact info
    </button>
  </div>
</template>
<script>
import { ref, onMounted } from 'vue';
import { NInput, NSpace } from 'naive-ui';

export default {
  components: {
    NInput,
    NSpace,
  },
  setup() {
    let modalShow = ref(false);
    const profileEmail = ref('');
    const profilePhone = ref('');

    const closeModal = () => {
      modalShow.value = false;
    };

    const openModal = () => {
      modalShow.value = true;
    };

    const handleSubmit = () => {
      //submit
      debugger
    };

    onMounted(()=>{
      //func that assigns value to email & phone_no
      profileEmail.value = 'ali.zafar@devsinc.com'
    })

    return {
      modalShow,
      profileEmail,
      profilePhone,
      closeModal,
      openModal,
      handleSubmit,
      onlyAllowNumber: (value) => !value || /^\d+$/.test(value),
    };
  },
};
</script>
