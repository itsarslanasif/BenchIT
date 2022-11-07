<template>
  <form @submit.prevent="handleSubmit()">
    <div v-if="activePhase == 1" id="workspace-info">
      <h4>Tell us about your team</h4>
      <label>What will your team use Slack for?</label>
      <select v-model="workspace.workspace_type">
        <option value="work">Work</option>
        <option value="school">School</option>
        <option value="shared_interest">Shared Interest group</option>
        <option value="other">Other</option>
      </select>
      <label>What kind of company is it?</label>
      <select v-model="workspace.organization_type">
        <option value="consumer_goods">Customer Goods</option>
        <option value="financial_services">Financial Services</option>
        <option value="government">Government</option>
        <option value="healthCare_pharmacutical">
          Healthcare/Pharmaceutical
        </option>
        <option value="media">Media</option>
        <option value="non_profit">Nonprofit</option>
      </select>
      <label>How big is your company?</label>
      <input v-model="workspace.capacity" type="number" required />
      <div v-if="capacityError" class="error">{{ capacityError }}</div>

      <label>What is your role there?</label>
      <select v-model="workspace.admin_role">
        <option value="administrative">Administrative/Facilities</option>
        <option value="accounting">Accounting/Finance</option>
        <option value="business_development">Business Development</option>
        <option value="business_owner">Business Owner</option>
        <option value="customer_support">Customer Support</option>
      </select>
      <div
        class="imagePreviewWrapper"
        :style="{ 'background-image': `url(${workspace.previewImage})` }"
        @click="selectImage"
      />
      <input ref="fileInput" type="file" @input="pickFile" />
      <div class="nextBtn">
        <button>Continue to Company Name</button>
      </div>
    </div>

    <div v-if="activePhase == 2" id="compnay-info">
      <h4>What's your company called?</h4>
      <label>Company name</label>
      <input
        v-model="workspace.company_name"
        type="text"
        placeholder="Ex. Acme or Acme Marketing"
        required
      />
      <h6>
        We'll use this to name your Slack workspace, which you can always change
        later.
      </h6>
      <div class="nextBtn">
        <button>Continue to Workspace URL</button>
      </div>
    </div>

    <div v-if="activePhase == 3" id="workspace-url">
      <h4>What URL do you want for your Slack workspace?</h4>
      <h6>Choose the address you'll use to sign in to Slack</h6>
      <label>Your workspace URL</label>
      <input
        v-model="workspace.slack_URL"
        type="text"
        placeholder="acme.slack.com"
        required
      />
      <h6>
        We'll use this to name your Slack workspace, which you can always change
        later.
      </h6>
      <div class="nextBtn">
        <button>Create Workspace</button>
      </div>
    </div>
  </form>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      activePhase: 1,
      capacityError: '',
      workspace: {
        workspace_type: 'work',
        organization_type: 'consumer_goods',
        admin_role: 'administrative',
        capacity: 0,
        slack_URL: '',
        company_name: '',
        previewImage: null,
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
          this.workspace.previewImage = e.target.result;
        };
        reader.readAsDataURL(file[0]);
        this.$emit('input', file[0]);
      }
    },
    handleSubmit() {
      if (this.activePhase === 3) {
        axios
          .post('http://localhost:3000/workspaces', this.workspace)
          .then(response => {
            return response.data;
          })
          .catch(error => {
            return error;
          });
      } else if (this.workspace.capacity <= 0) {
        this.capacityError = 'Company should have at least one member';
      } else {
        this.activePhase += 1;
        this.capacityError = '';
      }
    },
  },
};
</script>

<style scoped>
form {
  max-width: 500px;
  margin: 30px auto;
  background: #eee;
  text-align: left;
  padding: 40px;
  border-radius: 10px;
}

label {
  color: rgb(125, 125, 125);
  display: inline-block;
  margin: 25px 0 15px;
  font-size: 1.2em;
  letter-spacing: 1px;
  font-weight: bold;
}
input,
select {
  display: block;
  padding: 10px 6px;
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  border: 1px solid #ddd;
  color: #555;
}
button {
  background: rgb(36, 35, 35);
  border: 0;
  padding: 10px 20px;
  margin-top: 20px;
  color: white;
  cursor: pointer;
  border-radius: 5px;
  font-size: 1.3em;
}
.nextBtn {
  text-align: center;
}
strong {
  font-size: medium;
}
.imagePreviewWrapper {
  background-repeat: no-repeat;
  width: 100%;
  height: 200px;
  display: block;
  cursor: pointer;
  margin: 30px auto 30px;
  background-size: contain;
  background-position: center center;
  border: 1px solid #ddd;
}
.error {
  color: rgb(151, 23, 23);
  margin-top: 10px;
  font-size: 1.5em;
  font-weight: bold;
}
</style>
