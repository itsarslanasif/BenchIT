<template lang="">
  <div>
    <div class="my-3">
      <strong>{{ sidebarSettings.alwaysShowOnSidebar.title }}</strong>
      <div class="mt-2">
        <div v-for="item in sidebarSettings.alwaysShowOnSidebar.settings">
          <input type="checkbox" :id="item.field" />
          <label :for="item.field" class="pl-3">
            {{ item.label }}
          </label><br />
        </div>
      </div>
    </div>
    <hr class="my-3" />
    <div>
      <strong>{{ sidebarSettings.show.title }}</strong>
      <div v-for="item in sidebarSettings.show.settings">
        <input type="radio" :id="item.field" />
        <label :for="item.field" class="pl-3">{{ item.label }}</label
        ><br />
      </div>
    </div>
    <hr class="my-3" />
    <div>
      <strong>{{ sidebarSettings.sort.title }}</strong>
      <div>
        <div v-for="item in sidebarSettings.sort.settings">
          <input type="radio" :id="item.field" />
          <label :for="item.field" class="pl-3">
            {{ item.label }}
            </label><br />
        </div>
      </div>
    </div>
    <hr class="my-3" />
    <div class="my-3">
      <div v-for="item in sidebarSettings.other.settings">
        <input type="checkbox" :id="item.field" />
        <label :for="item.field" class="pl-3">
          {{ item.label }}
          </label><br />
      </div>
    </div>
  </div>
</template>
<script>
import { sidebarSettings } from '../../../assets/settings/sidebar';
export default {
  data() {
    return {
      sidebarSettings,
    };
  },
};
</script>
<style lang=""></style>
