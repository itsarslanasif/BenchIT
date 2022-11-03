<template>
  <form @submit.prevent="handleSubmit">
    <h1>Tell us about your team</h1>
    <label>What will your team use Slack for?</label>
    <select v-model="workspace_type">
      <option value="work">Work</option>
      <option value="school">School</option>
      <option value="shared_interest">Shared Interest group</option>
      <option value="other">Other</option>
    </select>
    <label>What kind of company is it?</label>
    <select v-model="organization_type">
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
    <select v-model="capacity">
      <option value="1-10 people">1-10 people</option>
      <option value="11-50 people">11-50 people</option>
      <option value="51-100 people">51-100 people</option>
      <option value="101-250 people">101-250 people</option>
      <option value="251-500 people<">251-500 people</option>
      <option value="501-1000 people">501-1000 people</option>
      <option value="More than 1000 people">More than 1000 people</option>
    </select>
    <label>What is your role there?</label>
    <select v-model="admin_role">
      <option value="administrative">Administrative/Facilities</option>
      <option value="accounting">Accounting/Finance</option>
      <option value="business_development">Business Development</option>
      <option value="business_owner">Business Owner</option>
      <option value="customer_support">Customer Support</option>
    </select>
    <div
      class="imagePreviewWrapper"
      :style="{ 'background-image': `url(${previewImage})` }"
      @click="selectImage"
    ></div>
    <input ref="fileInput" type="file" @input="pickFile" />
    <div class="btn_workinfo">
      <h4>Are you a manager?(Do people report to you?)</h4>
      <button class="btn">Yes</button>
      <button class="btn">No</button>
    </div>
    <div class="next">
      <button>Continue to Company Name</button>
    </div>
  </form>
</template>

<script>
export default {
  data() {
    return {
      workspace_type: '',
      organization_type: '',
      admin_role: '',
      capacity: '',
      previewImage: null,
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
          this.previewImage = e.target.result;
        };
        reader.readAsDataURL(file[0]);
        this.$emit('input', file[0]);
      }
    },
    handleSubmit() {
      this.$router.push('/company_info');
    },
  },
};
</script>

<style>
.btn {
  margin-left: 3px;
  width: 170px;
}
.btn_workinfo {
  text-align: center;
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
</style>
