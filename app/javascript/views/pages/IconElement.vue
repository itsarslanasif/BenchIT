<template>
  <p>{{ icon }} {{ space }} {{ name }}</p>
</template>

<script>
export default {
name :"IconElement",

props:{
  icon:String,
  name:String,
  space:String
}

}
</script>

