<template>
  <div />
</template>

<script lang="ts">
import { defineComponent, useFetch, useRoute, useRouter } from '@nuxtjs/composition-api'
import { userStore } from '~/plugins/store-accessor'
import { $cookies } from '~/utils/cookies'

export default defineComponent({
  setup() {
    const router = useRouter()
    const route = useRoute()

    useFetch(async () => {
      try {
        $cookies.set('access-token', route.value.query.access_token)
        $cookies.set('client', route.value.query.client)
        $cookies.set('uid', route.value.query.uid)

        await userStore.getCurrentUser({ currentUser: null, isLogin: false })
        const currentUser = userStore.context.getters.currentUser
        const isLogin = userStore.context.getters.isUserLogin
        $cookies.set('auth', { user: currentUser, isLogin })
        router.push('/')
      } catch (e) {

      }
    })
  }
})
</script>
