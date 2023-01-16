<template>
  <transition name="modal-fade">
    <n-modal
      :on-after-leave="profileStatusStore.toggleProfileStatusPopUp"
      class="w-4/12"
      v-model:show="showModal"
      preset="card"
      title="Set a status"
      content="Are you sure?"
    >
      <div class="m-0 relative mt-5">
        <div class="mb-6">
          <n-input
            v-model:value="formValue.text"
            @keyup="toggleSteps()"
            :on-change="clearInputFields"
            clearable
            placeholder="What's your status?"
          >
            <template #prefix>
              <n-icon class="px-1">
                <span @click="setEmojiModal" class="cursor-pointer">
                  {{ formValue.emoji }}
                </span>
              </n-icon>
            </template>
          </n-input>
        </div>
      </div>
      <div v-if="showEmojiModal" class="absolute z-50">
        <EmojiPicker
          :toggleModal="toggleEmojiModal"
          :addReaction="addReaction"
        />
      </div>

      <!-- step two -->

      <div v-if="secondStep" class="m-0 relative mt-5">
        <div class="mb-6">
          <n-dropdown
            size="small"
            class="w-48"
            trigger="click"
            :options="clearAfterOptions"
            :show-arrow="true"
            @select="onSelectClearAfterOption"
          >
            <n-input
              class="w-full btn-primary text-left rounded-sm"
              :value="this.formValue.dateTimeString"
              :allow-input="false"
            >
              {{ formValue.dateTimeString }}
            </n-input>
          </n-dropdown>

          <div v-if="showDateTimeInputFields" class="flex mt-6 justify-between">
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

            @click="onClickSave"
            class="bg-success text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('actions.save') }}
          </n-button>
          <n-button
           v-if="!profile.status"
            @click="onClickCancel"
            class="bg-slate-600 text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('actions.cancel') }}
          </n-button>

          <n-button
            v-if="profile.status"
            @click="onClickCancel"
            class="bg-slate-600 text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            clear status
          </n-button>
        </div>
      </div>

      <!-- step one -->
      <div v-if="!secondStep">
        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">Recent</p>
            <div v-for="status in recentStatuses" :key="status.id">
              <statusRow :status="status" :selectOption="onSelectStatus" />
            </div>
          </div>
        </div>

        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">For Devsinc</p>
            <div v-for="status in workspaceStatuses" :key="status.id">
              <statusRow :status="status" :selectOption="this.onSelectStatus" />
            </div>
          </div>
        </div>

        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">Automatically updates</p>
            <statusRow
              :status="automaticallyUpdates"
              :selectOption="onSelectStatus"
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
import { useProfileStatusStore } from '../../../stores/useProfileStatusStore';
import { ref } from 'vue';
import { handleDateTime } from '../../../handleDateTime.js';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { setProfileStatus } from '../../../api/profiles/profileStatus';


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
    const currentProfile=useCurrentProfileStore();
    const currentWorkspace=useCurrentWorkspaceStore();
    return {
      currentProfileStore:currentProfile,
      profile: currentProfile.getCurrentProfile,
      workspace:currentWorkspace.getCurrentWorkspace,
      profileStatusStore,
      dateTimeStamp: ref(null),
    };
  },
  data() {
    return {
      handleDateTime: new handleDateTime(),
      showDateTimeInputFields: false,
      showEmojiModal: false,
      showModal: true,
      title: 'Set Status.',
      secondStep: false,
      formValue: {
        text: '',
        emoji: '🙂',
        clear_after: 1183135260000,
        dateTimeString: 'Today',
      },
      clearAfterOptions: [
        {
          label: 'Clear selection',
          key: 'Clear selection',
          disabled: true,
        },
        {
          label: "Don't clear",
          key: "Don't clear",
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
          clear_after: 3600,
          dateTimeString: 'Today',
          recent: true,
        },
        {
          id: 2,
          emoji: '🍑',
          text: 'Having_funasdasdasdasd',
          clear_after: 9600,
          dateTimeString: 'Today',
          recent: true,
        },
        {
          id: 3,
          emoji: '🎃',
          text: 'On_leaveasdasdasdasd',
          clear_after: 360,
          dateTimeString: 'Today',
          recent: true,
        },
      ],
      workspaceStatuses: [
        {
          id: 1,
          emoji: '🍉',
          text: 'Luncasdasdh',
          clear_after: 3600,
          recent: false,
        },
        {
          id: 2,
          emoji: '🍇',
          text: 'dinnsadadser',
          clear_after: 12000,
          recent: false,
        },
        {
          id: 3,
          emoji: '🌏',
          text: 'vocatasdasdion',
          clear_after: 1600,
          recent: false,
        },
      ],
      automaticallyUpdates: {
        id: 1,
        emoji: '🍉',
        text: 'Lunch',
        clear_after: 1183135260000,
        recent: false,
      },
    };
  },
  beforeMount() {

     if(this.profile.status){
      this.secondStep = true;
      this.formValue.text = this.profile?.status?.text
      this.formValue.emoji = this.profile?.status?.emoji
      this.clear_after=this.profile?.status?.clear_after
     }
    },
  methods: {


    addReaction(emoji) {
      this.formValue.emoji = emoji.i;
      this.setEmojiModal();
      console.log('emoji check: ', emoji.i == '🙂');
    },
    setEmojiModal() {
      this.toggleSteps();
      this.toggleEmojiModal();
    },
    onSelectClearAfterOption(key) {
      this.formValue.dateTimeString = String(key);
      this.onSelectTimeDate();
    },
    onClickSave() {
      // this.handleDateTime.convertStringToTimeStamp(

      //   this.formValue.dateTimeString

      // );
      let obj={
        "text_status":this.formValue.text,
        "emoji_status":this.formValue.emoji,
        "clear_status_after":"2023-01-06 19:41:00"
    }
      setProfileStatus(this.workspace.id,this.profile.id,obj).then(
          (response) => {
            console.log("andar aya ha ",response.status,this.profile.status)
            this.currentProfileStore.setProfileStatus(response.status)
          },)
      // this.profileStatusStore.setStatusApiCall(this.workspace.id,this.profile.id,this.formValue)
      this.profileStatusStore.toggleProfileStatusPopUp()
    },
    onClickCancel() {
      this.profileStatusStore.toggleProfileStatusPopUp()
    },
    onClickClearStatus() {},
    onSelectStatus(selectedOption) {
      this.formValue.text = selectedOption.text;
      this.formValue.emoji = selectedOption.emoji;
      this.formValue.dateTimeString = 'Choose date and time';
      this.secondStep=true;
      this.showDateTimeInputFields=true;
      console.log("....",this.handleDateTime.incremntTimeStampBySeconds(selectedOption.clear_after))
      this.dateTimeStamp = ref(this.handleDateTime.incremntTimeStampBySeconds(selectedOption.clear_after));
    },
    onSelectTimeDate() {
      this.showDateTimeInputFields =
        this.formValue.dateTimeString == 'Choose date and time';
    },
    toggleEmojiModal() {
      this.showEmojiModal = !this.showEmojiModal;
    },
    toggleSteps() {
      if (this.formValue.text != '' || this.formValue.emoji != '🙂') {
        this.secondStep = true;
      } else {
        this.secondStep = false;
      }
    },
    closeProfileStatusModal() {
      this.showModal = false;
    },
    clearInputFields() {
      this.formValue.dateTimeString = 'Today';
      this.formValue.emoji = '🙂';
      this.showDateTimeInputFields = false;
      this.dateTimeStamp = ref(null);
      this.toggleSteps();
    },
  },
};
</script>
