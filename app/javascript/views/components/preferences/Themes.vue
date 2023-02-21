<template lang="">
  <div>
    {{ themeSetting.title }}
    <div class="bg-gray-50 border-black-400 border rounded my-3">
      <div class="flex items-center px-5 py-3 border-b border-black-400">
        <div class="w-12">
          <img src="../../../assets/images/user.png" />
        </div>
        <div class="pt-1 pl-3 h-12">
          <strong>Slackbot</strong>
          <p>You look nice today.</p>
        </div>
      </div>
      <div class="py-3 px-5">
        <input type="radio" />
        <label class="px-3 font-semibold">Light</label>
      </div>
    </div>

    <div class="bg-black-900 text-white border rounded">
      <div class="flex items-center px-5 py-3 border-b">
        <div class="w-12">
          <img src="../../../assets/images/user.png" />
        </div>
        <div class="pt-1 pl-3 h-12">
          <strong>Slackbot</strong>
          <p>You look nice today.</p>
        </div>
      </div>
      <div class="py-3 px-5">
        <input type="radio" />
        <label class="px-3 font-semibold">Dark</label>
      </div>
    </div>

    <hr class="my-3" />

    <div>
      <strong>Colors</strong>
      <p>
        Customize the look of your workspace. Feeling adventurous? <br />
        <span class="text-info">Create a custom theme</span>
      </p>
    </div>

    <div>
      <p class="font-semibold pt-3 text-black-700">Tried and true</p>
      <div class="flex justify-between px-3">
        <div class="bg-gray-50 border rounded my-3 border-black-400">
          <div class="flex items-center px-5 py-3 border-b border-black-400">
            <div class="w-12">
              <img src="../../../assets/images/user.png" />
            </div>
            <div class="pt-1 pl-3 h-12">
              <strong>Slackbot</strong>
              <p>You look nice today.</p>
            </div>
          </div>
          <div class="py-3 px-5">
            <input type="radio" />
            <label class="px-3 font-semibold">Aubergine</label>
          </div>
        </div>
        <div class="bg-gray-50 border rounded my-3 border-black-400">
          <div class="flex items-center px-5 py-3 border-b border-black-400">
            <div class="w-12">
              <img src="../../../assets/images/user.png" />
            </div>
            <div class="pt-1 pl-3 h-12">
              <strong>Slackbot</strong>
              <p>You look nice today.</p>
            </div>
          </div>
          <div class="py-3 px-5">
            <input type="radio" />
            <label class="px-3 font-semibold"> Ochin</label>
          </div>
        </div>
      </div>
    </div>

    <div>
      <p class="font-semibold pt-3 text-black-700">Clean and minimal</p>
      <div class="flex justify-between px-3">
        <div class="bg-gray-50 border rounded my-3 border-black-400">
          <div class="flex items-center px-5 py-3 border-b border-black-400">
            <div class="w-12">
              <img src="../../../assets/images/user.png" />
            </div>
            <div class="pt-1 pl-3 h-12">
              <strong>Slackbot</strong>
              <p>You look nice today.</p>
            </div>
          </div>
          <div class="py-3 px-5">
            <input type="radio" />
            <label class="px-3 font-semibold">Aubergine</label>
          </div>
        </div>
        <div class="bg-gray-50 border rounded my-3 border-black-400">
          <div class="flex items-center px-5 py-3 border-b border-black-400">
            <div class="w-12">
              <img src="../../../assets/images/user.png" />
            </div>
            <div class="pt-1 pl-3 h-12">
              <strong>Slackbot</strong>
              <p>You look nice today.</p>
            </div>
          </div>
          <div class="py-3 px-5">
            <input type="radio" />
            <label class="px-3 font-semibold"> Ochin</label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { themeSetting } from '../../../assets/settings/themes';
export default {
  data() {
    return {
      themeSetting,
    };
  },
};
</script>
