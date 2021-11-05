<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="8">
        <keep-alive>
          <PostForm @getCommunity="sendCommunity" />
        </keep-alive>
      </v-col>
      <v-col cols="4" class="mt-16">
        <div v-if="item">
          <PostFormSlideItem :item="item" />
        </div>
          <PostingToInfo />
        <div>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref, useRoute } from "@nuxtjs/composition-api"

import PostingToInfo from '~/components/infomations/PostingToInfo.vue'
import PostFormSlideItem from '~/components/post/PostFormSlideItem.vue'
import PostForm from '~/components/post/PostForm.vue'
import { $axios } from "~/utils/api"
import { COMMUNITY_SUBMIT_ROUTE } from "~/plugins/const"

export default defineComponent({
  components: {
    PostingToInfo,
    PostFormSlideItem,
    PostForm
  },
  // middleware: ['identification'],
  setup() {
    const route = useRoute()

    const item = ref(null)

    onMounted(async () => {
      if (route.value.name === COMMUNITY_SUBMIT_ROUTE) {
        await sendCommunity(route.value.params.name)
      }
    })


    const sendCommunity = async (name: string) => {
      const response = await $axios.get(`/communities/${name}`)
      if (response.data) {
        item.value = response.data.community
      }
    }

    return {
      item,
      sendCommunity
    }
  }
})
</script>