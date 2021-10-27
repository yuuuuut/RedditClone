<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="10">
        <keep-alive>
          <PostForm />
        </keep-alive>
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
  // middleware: ['identification'],
  setup() {
  }
})
</script>