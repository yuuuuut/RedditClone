<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="10">
        <PostForm />
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent } from "@nuxtjs/composition-api"
import PostForm from '~/components/post/PostForm.vue'

export default defineComponent({
  components: {
    PostForm
  },
  // beforeRouteLeave(to, from, next) {
  //   // this.test()
  //   if (to.name !== "r-name-submit") {
  //     localStorage.removeItem('post-value')
  //     localStorage.removeItem('post-image')
  //   }
  //   next()
  // },
  setup() {
  }
})
</script>

<style lang="scss" scoped>
</style>