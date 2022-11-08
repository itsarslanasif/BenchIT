<template>
  <form class="workspace-form" @submit.prevent="handleSubmit()">
    <div v-if="activePhase == 1" id="workspace-info">
      <h4>Tell us about your team</h4>
      <label class="form-label">What will your team use it for?</label>
      <select v-model="workspace.workspace_type" class="form-input-select">
        <option value="work">Work</option>
        <option value="school">School</option>
        <option value="shared_interest">Shared Interest group</option>
        <option value="other">Other</option>
      </select>
      <label class="form-label">What kind of company is it?</label>
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
        type="number"
        required
        class="form-input-select"
      />
      <div v-if="capacityError" class="error">{{ capacityError }}</div>

      <label class="form-label">What is your role there?</label>
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
        class="form-input-select"
        @input="pickFile"
      />
      <div class="next-btn">
        <button class="form-btn">Continue to Company Name</button>
      </div>
    </div>

    <div v-if="activePhase == 2" id="compnay-info">
      <h4>What's your company called?</h4>
      <label class="form-label">Company name</label>
      <input
        v-model="workspace.company_name"
        type="text"
        class="form-input-select"
        placeholder="Ex. Acme or Acme Marketing"
        required
      />
      <h6>
        We'll use this to name your workspace, which you can always change
        later.
      </h6>
      <div class="next-btn">
        <button class="form-btn">Continue to Workspace URL</button>
      </div>
    </div>

    <div v-if="activePhase == 3" id="workspace-url">
      <h4>What URL do you want for your workspace?</h4>
      <h6>Choose the address you'll use to sign in to Bench-it</h6>
      <label class="form-label">Your workspace URL</label>
      <input
        v-model="workspace.benchIT_URL"
        type="text"
        class="form-input-select"
        placeholder="acme.benchit.com"
        required
      />
      <div class="next-btn">
        <button class="form-btn">Create Workspace</button>
      </div>
    </div>
  </form>
</template>

<script>
import axios from './axios';
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
.workspace-form {
  background: #eee;
  border-radius: 10px;
  margin: 30px auto;
  max-width: 500px;
  padding: 40px;
  text-align: left;
}

.form-label {
  color: rgb(125, 125, 125);
  display: inline-block;
  font-size: 1.2em;
  font-weight: bold;
  letter-spacing: 1px;
  margin: 25px 0 15px;
}
.form-input-select {
  border: 1px solid #ddd;
  box-sizing: border-box;
  color: #555;
  display: block;
  height: 100%;
  padding: 10px 6px;
  width: 100%;
}
.form-btn {
  background: rgb(36, 35, 35);
  border-radius: 5px;
  border: 0;
  color: white;
  cursor: pointer;
  font-size: 1.3em;
  margin-top: 20px;
  padding: 10px 20px;
}
.next-btn {
  text-align: center;
}
.image-preview-wrapper {
  background-position: center center;
  background-repeat: no-repeat;
  background-size: contain;
  border: 1px solid #ddd;
  cursor: pointer;
  display: block;
  height: 200px;
  margin: 30px auto 30px;
  width: 100%;
}
.error {
  color: rgb(151, 23, 23);
  font-size: 1.5em;
  font-weight: bold;
  margin-top: 10px;
}
</style>
