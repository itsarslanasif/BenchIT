<template>
  <form class="form" @submit.prevent="handleSubmit()">
    <div v-if="activePhase == 1" id="workspace-info">
      <h3 class="form-h3">Tell us about your team</h3>
      <label>What will your team use it for?</label>
      <select v-model="workspace.workspace_type" class="form-input-select">
        <option value="work">Work</option>
        <option value="school">School</option>
        <option value="shared_interest">Shared Interest group</option>
        <option value="other">Other</option>
      </select>
      <label>What kind of company is it?</label>
      <select v-model="workspace.organization_type" class="form-input-select">
        <option value="consumer_goods">Customer Goods</option>
        <option value="financial_services">Financial Services</option>
        <option value="government">Government</option>
        <option value="healthCare_pharmacutical">
          Healthcare/Pharmaceutical
        </option>
        <option value="media">Media</option>
        <option value="non_profit">Nonprofit</option>
      </select>
      <label class="form-label">How big is your company?</label>
      <input
        v-model="workspace.capacity"
        class="form-input-select"
        type="number"
        required
      />
      <div v-if="capacityError" class="error">{{ capacityError }}</div>
      <label>What is your role there?</label>
      <select v-model="workspace.admin_role" class="form-input-select">
        <option value="administrative">Administrative/Facilities</option>
        <option value="accounting">Accounting/Finance</option>
        <option value="business_development">Business Development</option>
        <option value="business_owner">Business Owner</option>
        <option value="customer_support">Customer Support</option>
      </select>
      <div
        class="image-preview-wrapper"
        :style="{ 'background-image': `url(${workspace.workspace_avatar})` }"
        @click="selectImage"
      />
      <input
        ref="fileInput"
        type="file"
        @input="pickFile"
        class="form-input-select"
      />
      <div class="btn-div">
        <button class="form-btn">Continue to Company Name</button>
      </div>
    </div>

    <div v-if="activePhase == 2" id="compnay-info">
      <h4 class="form-h">What's your company called?</h4>
      <label>Company name</label>
      <input
        v-model="workspace.company_name"
        type="text"
        class="form-input-select"
        placeholder="Ex. Acme or Acme Marketing"
        required
      />
      <p class="form-h">
        We'll use this to name your workspace, which you can always change
        later.
      </p>
      <div class="btn-div">
        <button class="form-btn">Continue to Workspace URL</button>
      </div>
    </div>

    <div v-if="activePhase == 3" id="workspace-url">
      <h4 class="form-h">What URL do you want for your workspace?</h4>
      <h6 class="form-h">Choose the address you'll use to sign in</h6>
      <label>Your workspace URL</label>
      <input
        v-model="workspace.benchIT_URL"
        class="form-input-select"
        type="text"
        placeholder="acme@benchit.com"
        required
      />
      <div class="btn-div">
        <button class="form-btn">Create Workspace</button>
      </div>
    </div>
  </form>
</template>

<script>
import axios from './axios';
import './style.css';
export default {
  data() {
    return {
      activePhase: 1,
      capacityError: '',
      workspace: {
        admin_role: '',
        capacity: 1,
        company_name: '',
        organization_type: '',
        workspace_avatar: null,
        benchIT_URL: '',
        workspace_type: '',
      },
    };
  },
  methods: {
    selectImage() {
      this.$refs.fileInput.click();
    },
    pickFile() {
      let input = this.$refs.fileInput;
      let file = input.files;
      if (file && file[0]) {
        let reader = new FileReader();
        reader.onload = e => {
          this.workspace.workspace_avatar = e.target.result;
        };
        reader.readAsDataURL(file[0]);
        this.$emit('input', file[0]);
      }
    },
    handleSubmit() {
      if (this.activePhase === 3) {
        axios
          .post('workspaces', this.workspace)
          .then(response => {
            return response.data;
          })
          .catch(error => {
            return error;
          });
      } else if (
        this.workspace.capacity <= 0 ||
        this.workspace.capacity > 5000
      ) {
        this.capacityError =
          'Members should be greter than 0 and less than 5000';
      } else {
        this.activePhase += 1;
        this.capacityError = '';
      }
    },
  },
};
</script>

<style scoped>
input::file-selector-button {
  background-color: black;
  border: 0;
  color: rgb(235, 229, 229);
  margin-left: 3px;
  padding: 10px 20px;
}
</style>

