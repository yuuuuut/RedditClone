<template>
  <div>
    <p>
      {{ title }}
    </p>
    <v-btn @click="clickBtn">
      Click!
    </v-btn>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from '@vue/composition-api'
import { $axios } from '../utils/api'

export default defineComponent({
  setup() {
    const title = ref('Test')

    const clickBtn = async () => {
      const response = await $axios.get('/api/v1/posts')
      title.value = response.data.posts[0].name
      console.log(response)
    }
    
    return {
      title, clickBtn
    }
  }
})
</script>
