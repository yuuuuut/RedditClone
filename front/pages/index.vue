<template>
  <div>
    <p>
      {{ title }}
    </p>
    <v-btn @click="clickBtn">
      Click!
    </v-btn>
    <v-btn @click="login">
      Login
    </v-btn>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from '@vue/composition-api'
import { $axios } from '../utils/api'

export default defineComponent({
  setup() {
    const title = ref('Test')

    const login = () => {
      location.href = 'http://127.0.0.1:3000/api/v1/auth/twitter'
      // const response = await $axios.get('/api/v1/auth/twitter')
      // console.log(response)
    }

    const clickBtn = async () => {
      const response = await $axios.get('/posts')
      title.value = response.data.posts[0].name
      console.log(response)
    }
    
    return {
      title, clickBtn, login
    }
  }
})
</script>
