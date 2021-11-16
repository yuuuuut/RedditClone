<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols="8">
        <PostForm @getSideItem="sendSideItem" />
      </v-col>
      <v-col cols="4" class="mt-16">
        <div v-if="item">
          <div v-if="sideItemType === 'user'">
            <PostFormUserSlideItem :item="item" />
          </div>
          <div v-if="sideItemType === 'community'">
            <PostFormCoomunitySlideItem :item="item" />
          </div>
        </div>
        <PostingToInfo />
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref, useRoute } from "@nuxtjs/composition-api"

import PostingToInfo from '~/components/infomations/PostingToInfo.vue'
import PostFormCoomunitySlideItem from '~/components/post/PostFormCoomunitySlideItem.vue'
import PostFormUserSlideItem from '~/components/post/PostFormUserSlideItem.vue'
import PostForm from '~/components/post/PostForm.vue'
import { $axios } from "~/utils/api"
import { COMMUNITY_SUBMIT_ROUTE, USER_SUBMIT_ROUTE } from "~/plugins/const"
import { PostType } from "~/types/post"

export default defineComponent({
  components: {
    PostingToInfo,
    PostFormCoomunitySlideItem,
    PostFormUserSlideItem,
    PostForm
  },
  // middleware: ['identification'],
  setup() {
    const route = useRoute()

    const sideItemType = ref<PostType>('none')
    const item = ref(null)

    onMounted(async () => {
      if (route.value.name === USER_SUBMIT_ROUTE) {
        await sendSideItem(route.value.params.name, 'user')
      }
      if (route.value.name === COMMUNITY_SUBMIT_ROUTE) {
        await sendSideItem(route.value.params.name, 'community')
      }
    })


    const sendSideItem = async (...args: [string, PostType]) => {
      if (args[1] === 'user') {
        const response = await $axios.get(`/account/users/${args[0]}`)
        if (response.data) {
          item.value = response.data.user
          sideItemType.value = 'user'
        }
      }
      if (args[1] === 'community') {
        const response = await $axios.get(`/communities/${args[0]}`)
        if (response.data) {
          item.value = response.data.community
          sideItemType.value = 'community'
        }
      }
      if (args[1] === 'none') {
        item.value = null
        sideItemType.value = 'none'
      }
    }

    return {
      item,
      sideItemType,
      sendSideItem
    }
  }
})
</script>