<template>
  <div>
    <FormulateForm class="Workspace-creation-form" v-model="formValues">
      <h2 class="form-title">Create Workspace</h2>

      <FormulateInput
        name="company-name"
        type="text"
        label="Company Name"
        placeholder="Company name"
        validation="required"
      />
      <FormulateInput
        name="workspace-URL"
        type="text"
        label="Workspace URL"
        placeholder="Workspace URL"
        validation="required"
      />
      <FormulateInput
        name="Workspace Capacity"
        type="number"
        label="Capacity"
        placeholder="Workspace Capacity"
        validation="required|max:5000|min:1"
      />

      <FormulateInput
        :options="{
          first: 'Consumer Goods',
          second: 'Financial Services',
          third: 'Government',
          fourth: 'Healthcare/Pharmacutical',
          fifth: 'media',
          sixth: 'Non Profit',
        }"
        type="select"
        placeholder="Select an option"
        label="What is the type of your Organization?"
      />

      <FormulateInput
        :options="{
          first: 'Administrative',
          second: 'Accounting',
          third: 'Business Development',
          fourth: 'Business Ownwer',
          fifth: 'Customer Support',
        }"
        type="select"
        placeholder="Select an option"
        label="What is your role in the organization?"
      />

      <FormulateInput
        :options="{
          1: 'Work',
          2: 'School',
          3: 'Shared Interest',
          4: 'Other',
        }"
        type="select"
        placeholder="Select an option"
        label="What is type of your Workspace?"
      />

      <FormulateInput type="submit" label="Register" />
      <pre class="code" v-text="formValues" />
    </FormulateForm>
  </div>
</template>

<script>
export default {
  data() {
    return {
      formValues: {},
    };
  },
};
</script>

<style scoped>
.login-form {
  padding: 2em;
  border: 1px solid #a8a8a8;
  border-radius: 0.5em;
  max-width: 500px;
  box-sizing: border-box;
}
.form-title {
  margin-top: 0;
}
.login-form::v-deep .formulate-input .formulate-input-element {
  max-width: none;
}
@media (min-width: 420px) {
  .double-wide {
    display: flex;
  }
  .double-wide .formulate-input {
    flex-grow: 1;
    width: calc(50% - 0.5em);
  }
  .double-wide .formulate-input:first-child {
    margin-right: 0.5em;
  }
  .double-wide .formulate-input:last-child {
    margin-left: 0.5em;
  }
}
</style>
