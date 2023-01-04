<template>
  <transition name="modal-fade">
    <n-modal
      :on-after-leave="toggleProfileStatusPopUp"
      class="w-4/12"
      v-model:show="toggleModel"
      preset="card"
      title="Set a status"
      content="Are you sure?"
    >
      <div class="m-0 relative mt-5">
        <div class="mb-6">
          <n-input
            v-model:value="formValue.text"
            @keyup="toggleSteps()"
            :on-change="clearAll"
            clearable
            placeholder="What's your status?"
          >
            <template #prefix>
              <n-icon class="px-1">
                <span
                  @click="setEmojiModal"
                  class="cursor-pointer"
                >
                  {{ formValue.emoji }}
                </span>
              </n-icon>
            </template>
          </n-input>
        </div>
      </div>
      <div v-if="openEmojiModal" class="absolute z-50">
        <EmojiPicker :addReaction="addReaction" />
      </div>

      <!-- step two -->

      <div v-if="step2" class="m-0 relative mt-5">
        <div class="mb-6">
          <n-dropdown
            size="huge"
            class="w-48"
            trigger="click"
            :options="options"
            :show-arrow="true"
            @select="handleSelect"
          >

            <n-input
              class="w-full btn-primary text-left rounded-sm"
              :value="selectedClearTime"
              :allow-input="false"
            >
              {{ selectedClearTime }}
        </n-input>
          </n-dropdown>

          <div v-if="showDateTimeSelect" class="flex mt-6 justify-between">
            <n-date-picker
              class="w-6/12"
              v-model:value="dateTimeStamp"
              type="date"
            />
            <n-time-picker
              class="w-2/5"
              v-model:value="dateTimeStamp"
              size="medium"
            />
          </div>
        </div>
        <div class="p-2">
          <n-button
            @click="handleCreate"
            class="bg-success text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('actions.save') }}
          </n-button>
          <n-button
            @click="toggleModelf"
            class="bg-slate-600 text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('actions.cancel') }}
          </n-button>
        </div>
      </div>

      <!-- step one -->
      <div v-if="!step2">
        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">Recent</p>
            <div v-for="status in recentStatuses" :key="status.id">
              <statusRow :status="status" :selectOption="optionSelected" />
            </div>
          </div>
        </div>

        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">For Devsinc</p>
            <div v-for="status in workspaceStatuses" :key="status.id">
              <statusRow :status="status" :selectOption="this.optionSelected" />
            </div>
          </div>
        </div>

        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">Automatically updates</p>
            <statusRow
              :status="automstcally_Updates"
              :selectOption="optionSelected"
            />
          </div>
        </div>
      </div>
    </n-modal>
  </transition>
</template>
<script>
import {
  NForm,
  NFormItem,
  NButton,
  NInput,
  NDatePicker,
  NDropdown,
  NModal,
  NTimePicker,
} from 'naive-ui';
import statusRow from './statusRow.vue';
import EmojiPicker from '../../widgets/emojipicker.vue';
import { useProfileStatusStore } from '../../../stores/useProfileStatusStore'
import { ref } from 'vue';
import {handleDateTime} from '../../../handleDateTime.js'

export default {
  name: 'CreateChannel',
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
    statusRow,
    EmojiPicker,
    NDatePicker,
    NDropdown,
    NModal,
    NTimePicker,
  },

  setup() {
    const profileStatusStore = useProfileStatusStore();

    return {
      profileStatusStore,
      dateTimeStamp: ref(null),
    };
  },
  data() {
    return {
      handleDateTime : new handleDateTime(),
      showDateTimeSelect:false,
      selectedClearTime: 'Today',
      openEmojiModal: false,
      toggleModel: true,
      title: 'Set Status.',
      step2: false,


      formValue: {
        text: '',
        emoji: '🙂',
        dateTimeStamp: 1183135260000,
      },
      options: [
        {
          label: 'Clear selection',
          key: 'Clear selection',
          disabled: true,
        },
        {
          label: '30 minutes',
          key: '30 minutes',
        },
        {
          label: '1 hour',
          key: '1 hour',
        },
        {
          label: '4 hours',
          key: '4 hours',
        },
        {
          label: 'Today',
          key: 'Today',
        },
        {
          label: 'This Week',
          key: 'This Week',
        },
        {
          label: 'Choose date and time',
          key: 'Choose date and time',
        },
      ],
      recentStatuses: [
        {
          id: 1,
          emoji: '🌏',
          text: 'AFkasdasdasdadasd',
          dateTimeStamp: 1183135260000,
          recent: true,
        },
        {
          id: 2,
          emoji: '🍑',
          text: 'Having_funasdasdasdasd',
          timestamp: 1183135260000,
          recent: true,
        },
        {
          id: 3,
          emoji: '🎃',
          text: 'On_leaveasdasdasdasd',
          timestamp: 1183135260000,
          recent: true,
        },
      ],

      workspaceStatuses: [
        {
          id: 1,
          emoji: '🍉',
          text: 'Luncasdasdh',
          timestamp: 1183135260000,
          recent: false,
        },
        {
          id: 2,
          emoji: '🍇',
          text: 'dinnsadadser',
          timestamp: 1183135260000,
          recent: false,
        },
        {
          id: 3,
          emoji: '🌏',
          text: 'vocatasdasdion',
          timestamp: 1183135260000,
          recent: false,
        },
      ],

      automstcally_Updates: {
        id: 1,
        emoji: '🍉',
        text: 'Lunch',
        timestamp: 1183135260000,
        recent: false,
      },
    };
  },
  methods: {
    handleSelect(key) {
      this.selectedClearTime = String(key);
      this.onSelectTimeDate();

    },
    toggleProfileStatusPopUp(){
      this.profileStatusStore.toggleProfileStatusPopUp()
    },
    addReaction(emoji) {

      this.formValue.emoji = emoji.i;
      this.setEmojiModal();
      console.log("emoji check: ",emoji.i=="🙂");
    },
    setEmojiModal() {
      this.toggleSteps();
      this.openEmojiModal = !this.openEmojiModal;
    },
    toggleModelf() {
      this.toggleModel = false;
    },
    optionSelected(selectedOption) {
      this.handleDateTime.convertToTimeStamp()
      this.formValue.text = selectedOption.text;
      this.formValue.emoji = selectedOption.emoji;
      this.formValue.dateTimeStamp = selectedOption.dateTimeStamp;
      this.step2=true;
    },
    onSelectTimeDate(){
      this.showDateTimeSelect= this.selectedClearTime=="Choose date and time"
    },
    clearAll(){

      this.selectedClearTime='Today';
      this.formValue.emoji = '🙂';
      this.showDateTimeSelect=false;
      this.dateTimeStamp= ref(null);
      this.toggleSteps();

    },
    toggleSteps() {
      if ( this.formValue.text!='' ||  this.formValue.emoji != '🙂') {
        this.step2 = true;
      } else {
        this.step2 = false;
      }
    },
  },
};
</script>


