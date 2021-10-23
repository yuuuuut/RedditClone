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
              v-if="isParameter && currentUser"
              class="mr-3"
              size="25"
            >
              <v-img :src="currentUser.image" />
            </v-avatar>
            <div v-else class="not-avatar mr-3" />
            <div
              v-if="isParameter && currentUser"
            >
              {{ currentUser.uname }}
            </div>
            <div v-else>
              Choose a community
            </div>
          </div>
        </template>
        <div>
          <div class="select-menu__user">
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
        <v-chip color="black" text-color="white" :disabled="!isParameter" @click="isDraftQuery.isQuery ? updatePost(true) : createPost">
          POST
        </v-chip>
      </div>
    </v-card>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, onBeforeUnmount, onMounted, ref, useContext, useRoute, useRouter } from "@nuxtjs/composition-api"
import { deleteObject, getDownloadURL, ref as r, uploadBytesResumable } from 'firebase/storage'
import { storage } from "~/plugins/firebase"
import { userStore } from "~/store"
import { PostData, Post } from "~/types/post"
import { UserPost } from "~/types/user"
import { $axios } from "~/utils/api"

export default defineComponent({
  setup() {
    const USER_SUBMIT_ROUTE = 'user-name-submit'

    const { error } = useContext()
    const route = useRoute()
    const router = useRouter()

    const tab = ref(null)
    const tabs = ref(['POST', 'IMAGE', 'LINK'])
    const draftDialog = ref(false)
    const isImageHover = ref(false)
    const draftPosts = ref<PostData[]>([])
    const isDraftPostsLoad = ref(true)
    const post = ref<Post>({
      id: 0,
      title: '',
      text: '',
      url: '',
      spoiler: false,
      nsfw: false,
      status: "public",
      type: "none",
      createdAt: null,
      postImage: {
        uid: '',
        url: ''
      }
    })

    /**
     * Computed
     */
    const isParameter = computed(() => {
      const name = route.value.name
      if (name === USER_SUBMIT_ROUTE) return true
      return false
    })
    const isDraftQuery = computed(() => {
      const r = route.value.query.draft
      return r ? { isQuery: true, draftId: r } : { isQuery: false, draftId: '' }
    })
    const currentUser = computed(() => {
      return userStore.currentUser
    })

    /**
     * Mounted
     */
    onMounted(async () => {
      await getDraftPosts()

      if (route.value.query.draft) {
        checkIsQueryDraftPost()
      }

      const postData = localStorage.getItem('post-value')
      if (postData) {
        post.value = JSON.parse(localStorage.getItem('post-value')!)
        localStorage.removeItem('post-value')
      }
    })

    /**
     * Unmount
     */
    onBeforeUnmount(() => {
      if (route.value.name === USER_SUBMIT_ROUTE ||
          route.value.name === 'submit'
      ) {
        if (post.value) {
          localStorage.setItem('post-value',  JSON.stringify(post.value))
        }
      }
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

    const changePostType = () => {
      if (route.value.name === USER_SUBMIT_ROUTE) {
        post.value.type = 'user'
      } else {
        post.value.type = 'none'
      }
    }

    const changePostTyprRouterPush = (post: Post, user: UserPost) => {
      if (post.type === 'user') {
        router.push(`/user/${user.uname}/submit?draft=${post.id}`)
      } else {
        router.push(`/submit?draft=${post.id}`)
      }
    }

    /**
     * Postを作成する。
     * parameterがuserだった場合はpostのtypeをuserとして作成。
     */
    const createPost = async () => {
      console.log('OK')
      changePostType()
      await $axios.post('/posts', { post: post.value })
      router.push('/')
    }

    const updatePost = async (postPublic: boolean) => {
      changePostType()
      post.value.status = (postPublic) ? 'public' : 'draft'
      try {
        const response = await $axios.put(`/account/posts/${route.value.query.draft}`, { post: post.value, post_image: post.value.postImage })
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
        post.value.status = 'draft'
      }
    }

    /**
     * DraftPostを作成する。作成後は作成したPostのIDを持つqueryを付与する。
     */
    const createDraftPost = async () => {
      changePostType()
      post.value.status = 'draft'
      const response = await $axios.post('/posts', { post: post.value, post_image: post.value.postImage })
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
      tab,
      tabs,
      draftDialog,
      post,
      isImageHover,
      isDraftQuery,
      draftPosts,
      isParameter,
      currentUser,
      checkIsQueryDraftPost,
      clickSelectUserItem,
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

.select-menu__user {
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