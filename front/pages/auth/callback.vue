<template>
  <div>
    <p @click="callback">Loading</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, useRoute, useRouter } from '@nuxtjs/composition-api'
import { userStore } from '~/plugins/store-accessor'
import { $axios } from '~/utils/api'

export default defineComponent({
  setup() {
    const router = useRouter()
    const route = useRoute()

    const title = ref('Test')

    onMounted(() => {
      callback()
    })

    const callback = () => {
      localStorage.setItem('access-token', route.value.query.access_token as string)
      localStorage.setItem('client', route.value.query.client as string)
      localStorage.setItem('uid', route.value.query.uid as string)

      $axios.get('/account/me').then(response => {
        if (response.status !== 200) throw new Error('error')
        const currentUser = response.data.current_user
        userStore.setUser(currentUser)
      }).catch((e) => {
        console.error(e)
      }).finally(() => {
        router.push('/')
      })
    }


    // async setUp () {
    //   await this.$auth.setUserToken(token).then(response => {
    //     this.$log.info('success callback')
    //     this.$store.dispatch('favorite/getFavarites')
    //     this.$store.dispatch('count/getUnreadNotificationCount')
    //     this.$store.dispatch('count/getUnreadMessageRoomCount')
    //     this.$router.push('/')
    //   }).catch(error => {
    //     this.$log.error('error occurred')
    //     if (error.response && error.response.data && error.response.data.errors) {
    //       if (error.response.data.errors.full_messages) {
    //         this.errors = error.response.data.errors.full_messages
    //       } else {
    //         this.errors = error.response.data.errors
    //       }
    //       this.$log.error(this.errors)
    //     } else {
    //       this.errors = ['予期せぬエラーが発生しました。', '時間をおいて、再度お試しください。']
    //       this.$log.error(error)
    //     }
    //     this.$toast.error(this.errors.join(''))
    //     this.$router.push('/login?error=true')
    //   })
    // }
    const login = () => {
      location.href = 'http://127.0.0.1:3000/api/v1/auth/twitter'
      // const response = await $axios.get('/api/v1/auth/twitter')
      // console.log(response)
    }
    
    
    return {
      title, login, callback
    }
  }
})
</script>
