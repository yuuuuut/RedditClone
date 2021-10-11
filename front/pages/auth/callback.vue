<template>
  <div>
    <p>Loading</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, useRoute, useRouter } from '@nuxtjs/composition-api'
import { userStore } from '~/plugins/store-accessor'

export default defineComponent({
  setup() {
    const router = useRouter()
    const route = useRoute()

    onMounted(() => {
      callback()
    })

    const callback = () => {
      localStorage.setItem('access-token', route.value.query.access_token as string)
      localStorage.setItem('client', route.value.query.client as string)
      localStorage.setItem('uid', route.value.query.uid as string)

      userStore.getCurrentUser()
      router.push('/')
    }
    
    return {
      callback
    }
  }
})
</script>
