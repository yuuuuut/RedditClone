<template>
  <nuxt-child v-if="!is" />
  <div v-else>
    <div class="community-header__image">
      <v-img :src="community.headerImage" class="community-header__image" />
    </div>
    <div class="community-subheader">
      <div class="community-subheader__content">
        <v-row no-gutters>
          <v-col cols="2">
            <div class="community-subheader__icon">
              <div class="community-subheader__icon-cover">
                <v-img :src="community.mainImage" class="icon-image"/>
              </div>
            </div>
          </v-col>
          <v-col cols="10">
            <div class="d-flex justify-space-between">
              <div>
                <div class="community-subheader__name">
                  {{ community.name }}
                </div>
                <div class="community-subheader__subname">
                  {{ community.path }}
                </div>
              </div>
              <div class="mt-1">
                <v-btn
                  v-if="!community.isJoin"
                  rounded
                  color="primary"
                  width="100"
                  @click="joinCommunity"
                >
                  Join
                </v-btn>
                <v-btn
                  v-else
                  rounded
                  outlined
                  color="primary"
                  width="100"
                  @click="leaveCommunity"
                >
                  Leave
                </v-btn>
              </div>
            </div>
          </v-col>
        </v-row>
      </div>
    </div>
    <v-container>
      <v-row no-gutters>
        <v-col ref="root" cols="8">
          <div style="width: 97%;">
            <PostHeader :current-select="currentSelect" :click-func="pushRouter" />
            <div v-for="post in posts" :key="post.id" class="mb-3">
              <Post :post="post" />
            </div>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script lang="ts">
import { useRoute, computed, defineComponent, onMounted, ref, onUnmounted } from '@nuxtjs/composition-api'

import PostHeader from '~/components/post/PostHeader.vue'

import { flashMessageStore } from '~/store'
import { Community } from '~/types/community'
import { Pagination } from '~/types/pagination'
import { Paths, PostData } from '~/types/post'
import { $axios } from '~/utils/api'

export default defineComponent({
  components: {
    PostHeader
  },
  setup() {
    const root = ref<HTMLElement | null>(null)
    const route = useRoute()
    const posts = ref<PostData[]>([])
    const currentSelect = ref<Paths>('root')
    const pagination = ref<Pagination>({
      currentPage: 1,
      limitValue: null,
      nextPage: null,
      prevPage: null,
      totalCount: null,
      totalPages: 1
    })
    const community = ref<Community>({
      name: '',
      description: '',
      mainImage: '',
      headerImage: '',
      path: '',
      isJoin: false
    })

    const is =  computed(() => {
      return route.value.name === 'r-name'
    })

    onMounted(async () => {
      window.addEventListener("scroll", handleScroll)

      if (route.value.query.sort) {
        if (route.value.query.sort === 'new') {
          currentSelect.value = 'new'
          await getCommunity('new')
        } else if (route.value.query.sort === 'top') {
          currentSelect.value = 'top'
          await getCommunity('top')
        } else {
          currentSelect.value = 'hot'
          await getCommunity('hot')
        }
      } else {
        currentSelect.value = 'hot'
        await getCommunity(undefined)
      }
    })
    onUnmounted(() => {
      window.removeEventListener("scroll", handleScroll)
    })

    const resetPagination = () => {
      pagination.value = {
        currentPage: 1,
        limitValue: null,
        nextPage: null,
        prevPage: null,
        totalCount: null,
        totalPages: 1
      }
    }

    const pushRouter = async (path: Paths) => {
      resetPagination()
      history.pushState({}, '', route.value.path + `?sort=${path}`)
      currentSelect.value = path
      posts.value = []
      const res = await $axios.get(`/communities/${route.value.params.name}?sort=${path}`)
      if (res.data) {
        posts.value.push(...res.data.community.posts)
        pagination.value = res.data.pagination
      }
    }

    const handleScroll = async () => {
      if (!pagination.value.nextPage && pagination.value.currentPage !== 1) return

      const elm = root.value as HTMLElement
      if (elm.getBoundingClientRect().bottom < window.innerHeight) {
        pagination.value.currentPage += 1
        const response = await $axios.get(`/communities/${route.value.params.name}?sort=${currentSelect.value}`, { params: { page: pagination.value.currentPage }})
        posts.value.push(...response.data.community.posts)
        pagination.value = response.data.pagination
      }
    }

    const getCommunity = async (query: string | undefined) => {
      try {
        if (query) {
          posts.value = []
          const response = await $axios.get(`/communities/${route.value.params.name}?sort=${query}`)
          if (response.data) {
            community.value = response.data.community
            posts.value.push(...response.data.community.posts)
            pagination.value = response.data.pagination
          }
        } else {
          const response = await $axios.get(`/communities/${route.value.params.name}`)
          if (response.data) {
            community.value = response.data.community
            posts.value.push(...response.data.community.posts)
            pagination.value = response.data.pagination
          }
        }
      } catch (e) {
      }
    }

    const joinCommunity = async () => {
      try {
        await $axios.post(`/account/communities/${route.value.params.name}/join`)
        community.value.isJoin = true
        flashMessageStore.createFlashMessage({
          message: 'Success Joined Community',
          type: 'SUCCESS'
        })
      } catch (e) {
      }
    }

    const leaveCommunity = async () => {
      try {
        await $axios.delete(`/account/communities/${route.value.params.name}/leave`)
        community.value.isJoin = false
        flashMessageStore.createFlashMessage({
          message: 'Success Leaved Community',
          type: 'SUCCESS'
        })
      } catch (e) {
      }
    }

    return {
      root,
      posts,
      currentSelect,
      getCommunity,
      pushRouter,
      community,
      joinCommunity,
      leaveCommunity,
      is
    }
  }
})
</script>

<style lang="scss" scoped>
.community-header__image {
  height: 250px;
  width: 100%;
}

.community-subheader {
  background: white;
  width: 100%;
  height: 100px;
}

.community-subheader__content {
  width: 850px;
  margin: 0 auto;
  height: 100%;
}

.community-subheader__icon {
  position: relative;
}

.community-subheader__icon-cover {
  position:  absolute;
  border-radius: 50%;
  width: 86px;
  height: 86px;
  background: white;
  top: -30px;
  left: 30px;
}

.icon-image {
  border-radius: 50%;
  width: 80px;
  height: 80px;
  background: white;
  margin: 3px;
}

.community-subheader__name {
  font-weight: bold;
  font-size: 28px;
}

.community-subheader__subname {
  font-size: 14px;
  color: rgb(120, 124, 126);
}
</style>