<template>
  <form @submit.prevent="handleSubmit">
    <h1>What's you name?</h1>
    <h4>This is how your teammates in Slack will see and refer to you</h4>
    <label>Full name</label>
    <input type="text" placeholder="Full name" required v-model="full_name" />
    <label>Display name (optional) </label>
    <input type="text" placeholder="Display name" v-model="display_name" />
    <h4>
      By default, Salck will use your full name - but you can choose something
      shorter if you'd like.
    </h4>
    <div class="check">
      <input type="checkbox" v-model="check" />
      <label>It's ok to send me email about the Slack service.</label>
    </div>
    <div class="next">
      <button>Continue to Password</button>
    </div>
  </form>
  {{ full_name }}
</template>

<script>
export default {
  name: 'NameForm',
  data() {
    return {
      full_name: "",
      display_name: "",
      check: false,
    };
  },
  methods: {
    handleSubmit() {
      this.$router.push("/password_form");
    },
  },
};
</script>

<style>
form {
  max-width: 420px;
  margin: 30px auto;
  background: white;
  text-align: left;
  padding: 40px;
  border-radius: 10px;
}
label {
  color: #aaa;
  display: inline-block;
  margin: 25px 0 15px;
  font-size: 0.9em;
  letter-spacing: 1px;
  font-weight: bold;
}
input,
select {
  display: block;
  padding: 10px 6px;
  width: 100%;
  box-sizing: border-box;
  border: 1px solid #ddd;
  color: #555;
}
input[type="checkbox"] {
  display: inline-block;
  width: 16px;
  margin: 0 10px 0 0;
  position: relative;
  top: 2px;
}
button {
  background: #555;
  border: 0;
  padding: 10px 20px;
  margin-top: 20px;
  color: white;
  cursor: pointer;
  border-radius: 5px;
}
.next {
  text-align: center;
}
</style>
