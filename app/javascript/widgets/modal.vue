<template>
    <div class="modalListStyle">
        <div v-for="modal in modalArray" :key="modal.title" class="modalItem" @click="modal.func">
            {{ modal.title }}
        </div>
    </div>
</template>

<script>
export default {
    name: 'modal',
    props: [
        "modalArray"
    ],
}
</script>

<style scoped>
.modalListStyle {
    border-radius: 4%;
    background-color: #18232bce;
    width: 30%;
}
.modalItem {
    padding: 20px;
    border-radius: 2%;
    transition-duration: 0.3s;
}
.modalItem:hover {
    background-color: #141d24e5;
    transition-duration: 0.3s;
}
</style>
