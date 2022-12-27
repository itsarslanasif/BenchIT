<template>
  <transition name="modal-fade">
    <div
      v-if="toggleModel"
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div
        class="modal rounded-md w-2/5 h-2/5 shadow-md bg-slate-50"
        role="dialog"
      >
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg">
              <h1>Set a status</h1>
            </div>
            <font-awesome-icon icon="fa-sharp fa-solid fa-plus" />
            <button
              type="button"
              class="w-1/6 py-1 px-1 text-base float-right rounded hover:bg-transparent hover:font-bold"
              @click="toggleModelf"
            >
              X
            </button>
          </header>

          <!-- shared -->

          <div class="m-0 relative mt-5">
            <div class="mb-6">
              <n-input
                v-model:value="formValue.text"
                @keyup="toggleSteps()"
                class="h-10"
                placeholder="What's your status?"
              >
                <template #prefix>
                  <n-icon class="px-1">
                    <span
                      @click="setEmojiModal"
                      onchange="toggleSteps"
                      class="cursor-pointer"
                    >
                      {{ formValue.emoji }}
                    </span>
                  </n-icon>
                </template>
              </n-input>
            </div>
          </div>

          <!-- step two -->

          <div v-if="step2" class="m-0 relative mt-5">
            <div class="mb-6">
              <n-date-picker
                v-model:value="timestamp"
                type="datetime"
                clearable
              />
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
          <div v-if="openEmojiModal" class="absolute z-50">
            <EmojiPicker :addReaction="addReaction" />
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
                  <statusRow
                    :status="status"
                    :selectOption="this.optionSelected"
                  />
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
          <div></div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import { NForm, NFormItem, NButton, NInput, NDatePicker } from 'naive-ui';
import statusRow from './statusRow.vue';
import EmojiPicker from '../../widgets/emojipicker.vue';
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
  },

  setup() {
    return {
      timestamp: 1183135260000,
    };
  },
  data() {
    return {
      openEmojiModal: false,
      toggleModel: true,
      title: 'Set Status.',
      step2: false,

      formValue: {
        text: '',
        emoji: '🙂',
        timestamp: 1183135260000,
      },
      recentStatuses: [
        {
          id: 1,
          emoji: '🌏',
          text: 'AFk',
          timestamp: 1183135260000,
          recent: true,
        },
        {
          id: 2,
          emoji: '🍑',
          text: 'Having_fun',
          timestamp: 1183135260000,
          recent: true,
        },
        {
          id: 3,
          emoji: '🎃',
          text: 'On_leave',
          timestamp: 1183135260000,
          recent: true,
        },
      ],

      workspaceStatuses: [
        {
          id: 1,
          emoji: '🍉',
          text: 'Lunch',
          timestamp: 1183135260000,
          recent: false,
        },
        {
          id: 2,
          emoji: '🍇',
          text: 'dinner',
          timestamp: 1183135260000,
          recent: false,
        },
        {
          id: 3,
          emoji: '🌏',
          text: 'vocation',
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
  props: [],
  mounted() {},
  setup() {
    return {};
  },
  methods: {
    addReaction(emoji) {
      console.log(emoji);
      this.formValue.emoji = emoji.i;
      this.setEmojiModal();
    },
    setEmojiModal() {
      console.log(this.openEmojiModal);
      this.openEmojiModal = !this.openEmojiModal;
    },
    toggleModelf() {
      this.toggleModel = false;
    },
    optionSelected(selectedOption) {
      this.formValue = selectedOption;
      console.log(selectedOption);
    },
    toggleSteps() {
      console.log(this.formValue);
      if (this.formValue.text != '' || this.formValue.emoji != '🙂') {
        this.step2 = true;
      } else {
        this.step2 = false;
      }
    },

  },
};
</script>

<style scoped>
.c {
  color: black;
}
</style>
