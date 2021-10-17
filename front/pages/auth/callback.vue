<template>
  <div>
    <p>Loading</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, useRoute, useRouter } from '@nuxtjs/composition-api'
import { userStore } from '~/plugins/store-accessor'
import { $cookies } from '~/utils/cookies'

export default defineComponent({
  setup() {
    const router = useRouter()
    const route = useRoute()

    onMounted(() => {
      callback()
    })

    const callback = () => {
      $cookies.set('access-token', route.value.query.access_token)
      $cookies.set('client', route.value.query.client)
      $cookies.set('uid', route.value.query.uid)

      userStore.getCurrentUser()
      router.push('/')
    }
    
    return {
      callback
    }
  }
})
</script>
