<template>
  <div @click="joinCom">
    Com
  </div>
</template>

<script lang="ts">
import { useRoute } from '@nuxtjs/composition-api'
import { defineComponent, onMounted } from '@vue/composition-api'
import { $axios } from '~/utils/api'

export default defineComponent({
  setup() {
    const route = useRoute()

    onMounted(async () => {
      const response = await $axios.get(`communities/${route.value.params.name}`)
      console.log(response)
    })

    const joinCom = async () => {
      const response = await $axios.post('/account/communities', { community_id: route.value.params.name })
    }

    return {
      joinCom
    }
  }
})
</script>