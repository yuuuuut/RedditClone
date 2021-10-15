<template>
  <v-row no-gutters>
    <v-col cols="10">
      <PostForm />
    </v-col>
  </v-row>
</template>

<script lang="ts">
import { defineComponent } from "@nuxtjs/composition-api"
import PostForm from '~/components/post/PostForm.vue'

export default defineComponent({
  components: {
    PostForm
  },
  setup() {
  }
})
</script>

<style lang="scss" scoped>
</style>