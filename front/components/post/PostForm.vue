<template>
  <div class="form">
    <div class="d-flex justify-space-between">
      <h3 class="mb-3">
        <div v-if="isDraftQuery.isQuery">Update a post</div>
        <div v-else>Create a post</div>
      </h3>
      <v-dialog
        v-model="draftDialog"
        width="500"
        scrollable
        no-click-animation
      >
        <template #activator="{ on, attrs }">
          <v-chip
            class="ma-2"
            color="primary"
            text-color="primary"
            outlined
            v-bind="attrs"
            :disabled="!draftPosts.length"
            v-on="on"
          >
            DRAFTS
            <v-avatar v-if="draftPosts.length" right class="blue-grey lighten-5">
              {{ draftPosts.length }}
            </v-avatar>
          </v-chip>
        </template>
        <v-card>
          <div class="pa-2">
            Drafts <span class="draft-post__length-text">{{ draftPosts.length }}/10</span>
          </div>
          <v-divider />
          <v-card-text class="draft-post__item">
            <div v-for="p in draftPosts" :key="p.post.id">
              <div class="py-1 px-2" @click="selectDraftPosr(p.post.id)">
                <div>{{ p.post.title }}</div>
                <div class="d-flex">
                  <div class="draft-post__sub-text">{{ p.user.uname }}</div>
                  <div class="draft-post__sub-text mx-1">・</div>
                  <div class="draft-post__sub-text">Draft saved {{ p.post.createdAt }}</div>
                </div>
              </div>
              <v-divider />
            </div>
          </v-card-text>
        </v-card>
      </v-dialog>
    </div>
    <v-divider class="divider" />
    <div class="target-select">
      <v-menu offset-y>
        <template #activator="{ on, attrs }">
          <div
            v-bind="attrs"
            class="target-select__content"
            v-on="on"
          >
            <v-avatar
              v-if="isParameter && !firstLoad"
              class="mr-3"
              size="25"
            >
              <template v-if="parameterType === 'user' && currentUser">
                <v-img :src="currentUser.image" />
              </template>
              <template v-if="parameterType === 'r' && currentCommunity">
                <v-img :src="currentCommunity.mainImage" />
              </template>
            </v-avatar>
            <div v-else class="not-avatar mr-3" />
            <div v-if="!firstLoad && isParameter && currentUser">
              <div v-if="parameterType === 'user'">
                user/{{ currentUser.uname }}
              </div>
              <div v-if="parameterType === 'r' && currentCommunity">
                r/{{ currentCommunity.name }}
              </div>
            </div>
            <div v-else>
              Choose a community
            </div>
          </div>
        </template>
        <div>
          <div class="select-menu">
            <div class="select-menu__item-title">your profile</div>
            <div
              v-if="currentUser"
              class="select-menu__item"
              @click="clickSelectUserItem"
            >
              <v-avatar class="mr-3" size="40" tile>
                <v-img :src="currentUser.image" />
              </v-avatar>
              <div>user/{{ currentUser.uname }}</div>
            </div>
          </div>
          <div v-if="communities.length" class="select-menu">
            <div class="select-menu__item-title">my communities</div>
            <div
              v-for="c in communities"
              :key="c.name"
              class="select-menu__item"
              @click="clickSelectCommunityItem(c.name)"
            >
              <v-avatar class="mr-3" size="40">
                <v-img :src="c.mainImage" />
              </v-avatar>
              <div>r/{{ c.name }}</div>
            </div>
          </div>
        </div>
      </v-menu>
    </div>
    <v-card>
      <v-tabs
        v-model="tab"
        background-color="white"
        grow
      >
        <v-tabs-slider></v-tabs-slider>
        <v-tab href="#tab-1">
          Post
        </v-tab>
        <v-tab href="#tab-2">
          Image
        </v-tab>
        <v-tab href="#tab-3">
          Link
        </v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab" class="pa-3">
        <v-tab-item
          v-for="(t, i) in tabs"
          :key="i"
          :value="'tab-' + String((Number(i) + 1))"
          :transition="false"
        >
          <v-card flat>
            <v-text-field
              v-model="post.title"
              placeholder="Title"
              hide-details="auto"
              outlined
              class="mb-2"
            />
            <div v-if="t === 'POST'">
              <v-textarea
                v-model="post.text"
                placeholder="Text(optional)"
                hide-details="auto"
                outlined
              />
            </div>
            <div v-if="t === 'IMAGE'">
              <div class="image-area">
                <div v-if="!post.postImage.url" class="image-area__inner">
                    <v-file-input
                      id="imageInput"
                      accept="image/*"
                      label="File input"
                      style="display: none;"
                      @change="imageUpload"
                    ></v-file-input>
                    <v-btn color="primary" @click="btnclick">Upload Image</v-btn>
                </div>
                <div v-else class="upload-image__area">
                  <img :src="post.postImage.url" class="image" @mouseover="imageMouseOver" @mouseleave="imageMouseLeave" />
                  <v-btn
                    v-show="isImageHover"
                    class="delete-icon mx-2"
                    fab
                    small
                    dark
                    color="black"
                    @click="deleteImage"
                    @mouseover="imageMouseOver"
                  >
                    <v-icon>
                      mdi-delete
                    </v-icon>
                  </v-btn>
                </div>
              </div>
            </div>
            <div v-if="t === 'LINK'">
              <v-text-field
                v-model="post.url"
                placeholder="Url"
                hide-details="auto"
                height="50"
                outlined
              />
            </div>
          </v-card>
        </v-tab-item>
      </v-tabs-items>
      <div class="d-flex pa-3">
        <v-chip
          :outlined="!post.spoiler"
          :color="post.spoiler ? 'black' : ''"
          :text-color="post.spoiler ? 'white': ''"
          class="mr-2"
          @click="post.spoiler = !post.spoiler"
        >
          <v-icon v-if="!post.spoiler" left>
            mdi-plus
          </v-icon>
          <v-icon v-else left>
            mdi-check
          </v-icon>
          spoiler
        </v-chip>
        <v-chip
          :outlined="!post.nsfw"
          :color="post.nsfw ? 'black' : ''"
          :text-color="post.nsfw ? 'white': ''"
          @click="post.nsfw = !post.nsfw"
        >
          <v-icon v-if="!post.nsfw" left>
            mdi-plus
          </v-icon>
          <v-icon v-else left>
            mdi-check
          </v-icon>
          nsfw
        </v-chip>
      </div>
      <v-divider />
      <div class="d-flex justify-end pa-3">
        <v-chip v-if="isDraftQuery.isQuery" :disabled="!isDraftQuery.isQuery" color="primary" class="mr-3" @click="updatePost(false)">
          UPDATE DRAFT
        </v-chip>
        <v-chip v-else :disabled="!post.title" color="primary" class="mr-3" @click="createDraftPost">
          SAVE DRAFT
        </v-chip>
        <v-chip v-if="isDraftQuery.isQuery" color="black" text-color="white" :disabled="!isParameter || !post.title" @click="updatePost(true)">
          POST
        </v-chip>
        <v-chip v-else color="black" text-color="white" :disabled="!isParameter || !post.title" @click="createPost">
          POST
        </v-chip>
      </div>
    </v-card>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, onBeforeUnmount, onDeactivated, onMounted, ref, useContext, useRoute, useRouter } from "@nuxtjs/composition-api"
import { deleteObject, getDownloadURL, ref as r, uploadBytesResumable } from 'firebase/storage'
import { AxiosResponse } from 'axios'
import { storage } from "~/plugins/firebase"
import { $axios } from "~/utils/api"
import { userStore } from "~/store"

import { PostData, Post, PostType, PostStatus } from "~/types/post"
import { Community } from "~/types/community"
import { UserPost } from "~/types/user"

let cashPost: Post | null = null

export default defineComponent({
  setup() {
    const ROOT_SUBMIT_ROUTE = 'submit'
    const USER_SUBMIT_ROUTE = 'user-name-submit'
    const COMMUNITY_SUBMIT_ROUTE = 'r-name-submit'
    const POST_TYPE: PostType = {
      none: 'none',
      user: 'user',
      community: 'community'
    }
    const POST_STATUS: PostStatus = {
      draft: 'draft',
      public: 'public'
    }

    const { error } = useContext()
    const route = useRoute()
    const router = useRouter()

    const firstLoad = ref(true)
    const tab = ref(null)
    const tabs = ref(['POST', 'IMAGE', 'LINK'])
    const draftDialog = ref(false)
    const isImageHover = ref(false)
    const draftPosts = ref<PostData[]>([])
    const isDraftPostsLoad = ref(true)
    const communities = ref<Community[]>([])
    const post = ref<Post>({
      id: 0,
      title: '',
      text: '',
      url: '',
      spoiler: false,
      nsfw: false,
      status: "public",
      type: "none",
      communityId: '',
      createdAt: null,
      postImage: {
        uid: '',
        url: ''
      }
    })

    onDeactivated(() => {
      cashPost = post.value as Post
    })

    /**
     * Computed
     */
    const isParameter = computed(() => {
      const name = route.value.name
      if (name === USER_SUBMIT_ROUTE) return true
      if (name === COMMUNITY_SUBMIT_ROUTE) return true
      return false
    })
    const parameterType = computed(() => {
      const name = route.value.name
      if (name === USER_SUBMIT_ROUTE) return 'user'
      if (name === COMMUNITY_SUBMIT_ROUTE) return 'r'
      return 'none'
    })
    const isDraftQuery = computed(() => {
      const r = route.value.query.draft
      return r ? { isQuery: true, draftId: r } : { isQuery: false, draftId: '' }
    })
    const currentUser = computed(() => {
      return userStore.currentUser
    })
    const currentCommunity = computed(() => {
      const paramValue = route.value.params.name
      const community = communities.value.find(c => {
        return c.name === paramValue
      })
      return community
    })

    /**
     * Mounted
     */
    onMounted(async () => {
      await getCurrentUserCommunities()
      await getDraftPosts()

      if (route.value.query.draft) {
        checkIsQueryDraftPost()
      }
      if (cashPost) {
        post.value = cashPost
      }
      firstLoad.value = false
    })

    /**
     * Unmount
     */
    onBeforeUnmount(() => {
      const routeName = route.value.name
      if (routeName === USER_SUBMIT_ROUTE ||
          routeName === COMMUNITY_SUBMIT_ROUTE ||
          routeName === ROOT_SUBMIT_ROUTE
      ) return
      cashPost = null
    })


    /**
     * Methods
     */

    /**
     * file input を擬似的にclickさせる。
     */
    const btnclick = () => {
      const elm = document.getElementById('imageInput') as HTMLElement
      elm.click()
    }

    const imageMouseOver = () => {
      isImageHover.value = true
    }

    const imageMouseLeave = () => {
      isImageHover.value = false
    }

    const getCurrentUserCommunities = async () => {
      try {
        const response = await $axios.get('account/communities')
        communities.value.push(...response.data.communities)
      } catch (e) {

      }
    }

    /**
     * queryで指定されたIDのPostがDraftPosts配列に存在しない場合
     * 404エラーを返す。
     */
    const checkIsQueryDraftPost = () => {
      const draftPost = draftPosts.value.find(p => {
        return String(p.post.id) === route.value.query.draft
      })
      if (!draftPost){
        error({ statusCode: 404 })
        return
      }
      post.value = draftPost.post
    }

    /**
     * statusがdraftのpostを取得する。
     */
    const getDraftPosts = async () => {
      const response = await $axios.get('/account/posts?status=draft')
      if (!response.data) return
      draftPosts.value = response.data.posts
      isDraftPostsLoad.value = false
    }

    /**
     * postIdで指定されたIDのstatusがdraftのpostを取得する。
     */
    const selectDraftPosr = async (postId: number) => {
      if (route.value.query.draft === String(postId)) {
        draftDialog.value = false
        return
      }
      const response = await $axios.get(`/account/posts/${postId}`)
      if (!response.data) return
      post.value = response.data.post
      draftDialog.value = false
      changePostTyprRouterPush(response.data.post, response.data.user)
    }

    /**
     * 
     */
    const clickSelectUserItem = () => {
      const draftId = route.value.query.draft
      if (!currentUser.value) return
      if (draftId) {
        router.push(`/user/${currentUser.value.uname}/submit?draft=${draftId}`)
      } else {
        router.push(`/user/${currentUser.value.uname}/submit`)
      }
    }

    const clickSelectCommunityItem = (name: string) => {
      const draftId = route.value.query.draft
      if (draftId) {
        router.push(`/r/${name}/submit?draft=${draftId}`)
      } else {
        router.push(`/r/${name}/submit`)
      }
    }

    /**
     * ParameterでPostのTypeを判定してセットする。
     */
    const changePostType = () => {
      switch (route.value.name) {
        case USER_SUBMIT_ROUTE:
          post.value.type = POST_TYPE.user
          break
        case COMMUNITY_SUBMIT_ROUTE:
          post.value.type = POST_TYPE.community
          break
        default:
          post.value.type = POST_TYPE.none
          break
      }
    }

    /**
     * ParameterでPostのTypeを判定して遷移先を変える。
     */
    const changePostTyprRouterPush = (post: Post, user: UserPost) => {
      switch (post.type) {
        case POST_TYPE.user:
          router.push(`/user/${user.uname}/submit?draft=${post.id}`)
          break
        case POST_TYPE.community:
          router.push(`/r/${post.communityId}/submit?draft=${post.id}`)
          break
        default:
          router.push(`/submit?draft=${post.id}`)
          break
      }
    }

    /**
     * Postを作成する。
     * parameterがuserだった場合はpostのtypeをuserとして作成。
     */
    const createPost = async () => {
      changePostType()
      await $axios.post('/posts', { post: post.value, post_image: post.value.postImage })
      router.push('/')
    }

    const updatePost = async (postPublic: boolean) => {
      changePostType()
      post.value.status = (postPublic) ? POST_STATUS.public : POST_STATUS.draft
      try {
        let response: AxiosResponse<any>
        if (post.value.type === POST_TYPE.community) {
          response = await $axios.put(`/account/posts/${route.value.query.draft}?community_id=${route.value.params.name}`, { post: post.value, post_image: post.value.postImage })
        } else {
          response = await $axios.put(`/account/posts/${route.value.query.draft}`, { post: post.value, post_image: post.value.postImage })
        }
        // const response = await $axios.put(`/account/posts/${route.value.query.draft}`, { post: post.value, post_image: post.value.postImage })
        if (!postPublic) {
          post.value = response.data.post
          draftPosts.value = draftPosts.value.filter(p => {
            return p.post.id !== response.data.post.id
          })
          draftPosts.value.push({ post: post.value, user: response.data.user })
        } else {
          router.push('/')
        }
      } catch (e) {
        post.value.status = POST_STATUS.draft
      }
    }

    /**
     * DraftPostを作成する。作成後は作成したPostのIDを持つqueryを付与する。
     */
    const createDraftPost = async () => {
      let response
      changePostType()
      post.value.status = POST_STATUS.draft
      if (post.value.type === POST_TYPE.community) {
        response = await $axios.post(`/posts?community_id=${route.value.params.name}`, { post: post.value, post_image: post.value.postImage })
      } else {
        response = await $axios.post('/posts', { post: post.value, post_image: post.value.postImage })
      }
      const resPost = response.data.post
      draftPosts.value.push(resPost)
      changePostTyprRouterPush(resPost, response.data.user)
    }

    const imageUpload = async (file: Blob) => {
      try {
        post.value.postImage.url = ''
        post.value.postImage.uid = ''
        post.value.postImage.uid = new Date().getTime().toString() + Math.floor(Math.random() * 10).toString()
        const storageRef = r(storage, `images/${post.value.postImage.uid}`)
        const task = uploadBytesResumable(storageRef, file)
        await task
        const url = await getDownloadURL(storageRef)
        post.value.postImage.url = url
      } catch (e) {
        post.value.postImage.url = ''
      }
    }

    const deleteImage = async () => {
      await $axios.$delete(`/post_images/${post.value.postImage.uid}`).then(async () => {
        const storageRef = r(storage, `images/${post.value.postImage.uid}`)
        await deleteObject(storageRef)
        post.value.postImage.uid = ''
        post.value.postImage.url = ''
      })
    }

    return {
      firstLoad,
      tab,
      tabs,
      draftDialog,
      post,
      communities,
      isImageHover,
      isDraftQuery,
      draftPosts,
      isParameter,
      currentUser,
      parameterType,
      currentCommunity,
      checkIsQueryDraftPost,
      clickSelectUserItem,
      clickSelectCommunityItem,
      getDraftPosts,
      selectDraftPosr,
      imageMouseOver,
      imageMouseLeave,
      btnclick,
      createPost,
      updatePost,
      createDraftPost,
      imageUpload,
      deleteImage,
    }
  }
})
</script>

<style lang="scss" scoped>
.v-menu__content {
  background-color: #fff;
  box-shadow: initial;
  border: 1px solid #dae0e6;
  max-height: 300px;
}

::v-deep .v-dialog {
  transition: initial !important;
}

.v-card__text {
  padding: initial !important;
  color: initial !important;
}

.form {
  max-width: 90%;
  margin-top: 20px;

  .divider {
    margin-bottom: 20px;
  }

  .target-select {
    margin-bottom: 10px;
  }

  .target-select__content {
    position: relative;
    max-width: 300px;
    height: 40px;
    background-color: white;
    border-radius: 5px;
    display: flex;
    align-items: center;
    padding: 0 10px;
  }

  .not-avatar {
    width: 22px;
    height: 22px;
    border-radius: 50%;
    border: 1px dashed gray;
  }
}

.draft-content {
  max-height: 200px;
}

.draft-post__item {
  max-height: 250px;
  cursor: pointer;
}

.draft-post__length-text {
  font-size: 13px;
}

.draft-post__sub-text {
  font-size: 14px;
  color: #8d8d8d;
}

.select-menu {
  border-bottom: 1px solid #dae0e6;
  padding: 15px;
}

.select-menu__item-title {
  font-size: 14px;
  color: gray;
  margin-bottom: 10px;
}

.select-menu__item {
  display: flex;
  align-items: center;
}

.image-area {
  border: 1px solid gray;
  border-radius: 3px;
  height: 250px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  .upload-image__area {
    display: flex;
    justify-content: start;
    position: relative;

    .image {
      max-width: 200px;
      max-height: 200px;
    }

    .delete-icon {
      position: absolute;
      right: 0;
      top: 10px;
    }
  }
}
</style>