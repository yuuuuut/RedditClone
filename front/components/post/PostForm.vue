<template>
  <div class="form">
    <div class="d-flex justify-space-between">
      <h3 class="mb-3">
        <div v-if="draftQuery">Update a post</div>
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
            <div v-for="p in draftPosts" :key="p.id">
              <div class="py-1 px-2" @click="selectDraftPosr(p.id)">
                <div>{{ p.title }}</div>
                <div class="d-flex">
                  <div class="draft-post__sub-text">{{ p.user.uname }}</div>
                  <div class="draft-post__sub-text mx-1">・</div>
                  <div class="draft-post__sub-text">Draft saved {{ p.createdAt }}</div>
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
      <v-menu v-model="selectMenu" offset-y>
        <template #activator="{ on }">
          <div
            class="target-select__content"
            v-on="on"
          >
            <v-avatar
              v-if="isParameter"
              class="mr-3"
              size="25"
            >
              <v-img :src="selectMenuImage" />
            </v-avatar>
            <div v-else class="not-avatar mr-3" />
            <div v-if="isParameter">
              {{ selectMenuName }}
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
          <div class="select-menu">
            <div class="d-flex justify-space-between mb-3">
              <div class="select-menu__item-title">my communities</div>
              <!-- Create New Community Dialog -->
              <v-dialog
                v-model="createCommunityDialog"
                width="500"
              >
                <template #activator="{ on, attrs }">
                  <div
                    v-bind="attrs"
                    class="select-menu__item-create"
                    v-on="on"
                    @click="clickCreateNewButton"
                  >
                    Create New
                  </div>
                </template>
                <v-card>
                  <v-card-title class="d-flex justify-space-between">
                    <div>Create a community</div>
                    <v-icon @click="createCommunityDialog = false">mdi-close</v-icon>
                  </v-card-title>
                  <v-divider></v-divider>
                  <div class="pa-3">
                    <div class="mb-10">
                      <div class="mb-6">
                        <label>Name</label>
                        <div class="community-dialog__subtext">Community names including capitalization cannot be changed.</div>
                      </div>
                      <v-text-field
                        v-model="community.name"
                        outlined
                        hide-details="auto"
                        class="community-create__name-input"
                        prefix="r/"
                        :maxlength="MAX_COMMUNITY_NAME"
                      />
                      <div class="community-dialog__subtext mt-1">{{ communityTextLength }} Characters remaining</div>
                    </div>
                    <div>
                      <div>
                        <label>Community type</label>
                      </div>
                      <v-radio-group  v-model="community.type">
                        <v-radio
                          v-for="t in communityTypes"
                          :key="t.type"
                          :value="t.type"
                        >
                          <template #label>
                            <div class="d-flex">
                              <v-icon size="17" class="mx-1">{{ t.icon }}</v-icon>
                              <div class="community-create__radio-text">{{ t.upperType }}</div>
                              <div class="community-create__radio-subtext">{{ t.subtext }}</div>
                            </div>
                          </template>
                        </v-radio>
                      </v-radio-group>
                    </div>
                  </div>
                  <v-divider></v-divider>
                  <v-card-actions class="grey lighten-2">
                    <div style="margin-left:auto">
                      <v-btn
                        rounded
                        outlined
                        color="primary"
                        class="mr-1"
                        @click="createCommunityDialog = false"
                      >
                        Cancel
                      </v-btn>
                      <v-btn
                        rounded
                        color="primary"
                        @click="createCommunity"
                      >
                        Create Community
                      </v-btn>
                    </div>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </div>
            <div v-if="communities.length">
              <div
                v-for="c in communities"
                :key="c.name"
                class="select-menu__item"
                @click="clickSelectCommunityItem(c.name, c.mainImage)"
              >
                <v-avatar class="mr-3" size="40">
                  <v-img :src="c.mainImage" />
                </v-avatar>
                <div>r/{{ c.name }}</div>
              </div>
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
              <VueEditor v-model="post.text" :editor-toolbar="customToolbar" />
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
        <v-chip v-if="draftQuery" :disabled="!draftQuery" color="primary" class="mr-3" @click="updatePost(false)">
          UPDATE DRAFT
        </v-chip>
        <v-chip v-else :disabled="!post.title" color="primary" class="mr-3" @click="createDraftPost">
          SAVE DRAFT
        </v-chip>
        <v-chip v-if="draftQuery" color="black" text-color="white" :disabled="!isParameter || !post.title" @click="updatePost(true)">
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
import { VueEditor } from  "vue2-editor"

import { computed, defineComponent, onMounted, ref, useContext, useRoute, useRouter, nextTick } from "@nuxtjs/composition-api"
import { deleteObject, getDownloadURL, ref as r, uploadBytesResumable } from 'firebase/storage'
import { AxiosResponse } from 'axios'

import {  MAX_COMMUNITY_NAME, USER_SUBMIT_ROUTE, COMMUNITY_SUBMIT_ROUTE } from '~/plugins/const'
import { storage } from "~/plugins/firebase"
import { $axios } from "~/utils/api"
import { userStore } from "~/store"

import { PostData, Post, PostType } from "~/types/post"
import { Community } from "~/types/community"

export default defineComponent({
  setup(_, context) {
    const { error } = useContext()
    const route = useRoute()
    const router = useRouter()

    const customToolbar = ref([
      ["bold", "italic", "underline"],
      [{ list: "ordered" }, { list: "bullet" }],
      [{ color: [] }],
      ["blockquote", "code-block"],
      ["image"]
    ])
    
    const selectMenu = ref(false)
    const selectMenuName = ref('')
    const selectMenuImage = ref('')
    const isParameter = ref(false)
    const draftQuery = ref(0)
    const selectCommunityName = ref('')
    const postType = ref<PostType>('none')

    const tab = ref(null)
    const tabs = ref(['POST', 'IMAGE', 'LINK'])
    const createCommunityDialog = ref(false)
    const draftDialog = ref(false)
    const isImageHover = ref(false)
    const draftPosts = ref<PostData[]>([])
    const communities = ref<Community[]>([])
    const post = ref<Post>({
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
    const community = ref({
      name: '',
      type: 'public',
    })
    const communityTypes = ref([
      { type: 'public', upperType: 'Public', icon: 'mdi-account', subtext: 'Anyone can view, post, and comment to this community' },
      { type: 'restricted', upperType: 'Restricted', icon: 'mdi-eye', subtext: 'Anyone can view this community, but only approved users can post' },
      { type: 'private', upperType: 'Private', icon: 'mdi-lock', subtext: 'Only approved users can view and submit to this community' }
    ])

    /**
     * Computed
     */
    const communityTextLength = computed(() => {
      return MAX_COMMUNITY_NAME - community.value.name.length
    })
    const currentUser = computed(() => {
      return userStore.currentUser
    })

    /**
     * Mounted
     */
    onMounted(async () => {
      await getCurrentUserCommunities()
      await getDraftPosts()

      if (route.value.name === USER_SUBMIT_ROUTE) {
        setSelectMenu(currentUser.value!.uname, currentUser.value!.image)
        isParameter.value = true
        postType.value = 'user'
      }
      if (route.value.name === COMMUNITY_SUBMIT_ROUTE) {
        const community = communities.value.find(c => {
          return route.value.params.name === c.name
        })
        if (!community) return
        setSelectMenu(community.name, community.mainImage)
        isParameter.value = true
        postType.value = 'community'
        context.emit('getCommunity', community.name)
      }
      if (route.value.query.draft) {
        checkIsQueryDraftPost()
      }
    })

    /**************
     * Methods
     **************/
    const btnclick = () => {
      const elm = document.getElementById('imageInput') as HTMLElement
      elm.click()
    }
    const clickCreateNewButton = () => {
      createCommunityDialog.value = true
      selectMenu.value = false
    }
    const imageMouseOver = () => {
      isImageHover.value = true
    }
    const imageMouseLeave = () => {
      isImageHover.value = false
    }

    const createCommunity = async () => {
      try {
        const response = await $axios.post('/account/communities', { community: community.value })
        const resCommunity = response.data.community
        communities.value.push(resCommunity)
        createCommunityDialog.value = false
        selectMenu.value = false
        selectCommunityName.value = resCommunity.name
        postType.value = 'community'
        setSelectMenu(resCommunity.name, resCommunity.mainImage)
        history.pushState({}, '', `/r/${resCommunity.name}/submit`)
      } catch (e) {
      }
    }

    const clickSelectUserItem = () => {
      if (!currentUser.value) return
      if (draftQuery.value) {
        history.pushState({}, '', `/user/${currentUser.value.uname}/submit?draft=${draftQuery.value}`)
      } else {
        history.pushState({}, '', `/user/${currentUser.value.uname}/submit`)
      }
      setSelectMenu(currentUser.value.uname, currentUser.value.image)
      postType.value = 'user'
    }

    const clickSelectCommunityItem = (name: string, image: string) => {
      if (draftQuery.value) {
        history.pushState({}, '', `/r/${name}/submit?draft=${draftQuery.value}`)
      } else {
        history.pushState({}, '', `/r/${name}/submit`)
      }
      setSelectMenu(name, image)
      context.emit('getCommunity', name)
      selectCommunityName.value = name
      postType.value = 'community'
    }

    const setSelectMenu = (name: string, image: string) => {
      isParameter.value = true
      selectMenuName.value = name
      selectMenuImage.value = image
    }

    /**
     * ParameterでPostのTypeを判定して遷移先を変える。
     */
    const changePostTyprRouterPush = (post: PostData) => {
      switch (post.type) {
        case 'user':
          history.pushState({}, '', `/user/${post.user.uname}/submit?draft=${post.id}`)
          setSelectMenu(post.user.uname, post.user.image)
          postType.value = 'user'
          break
        case 'community':
          history.pushState({}, '', `/r/${post.communityId}/submit?draft=${post.id}`)
          setSelectMenu(post.community!.name, post.community!.mainImage)
          postType.value = 'community'
          selectCommunityName.value = post.community!.name
          break
        default:
          history.pushState({}, '', `/submit?draft=${post.id}`)
          isParameter.value = false
          postType.value = 'none'
          break
      }
    }

/**
 * NG
 */
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
        return String(p.id) === route.value.query.draft
      })
      if (!draftPost){
        error({ statusCode: 404 })
        return
      }
      post.value = draftPost
    }

    /**
     * statusがdraftのpostを取得する。
     */
    const getDraftPosts = async () => {
      const response = await $axios.get('/account/posts?status=draft')
      if (!response.data) return
      draftPosts.value = response.data.posts
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
      draftQuery.value = postId
      changePostTyprRouterPush(response.data.post)
      context.emit('getCommunity', post.value.communityId)
    }

    /**
     * ParameterでPostのTypeを判定してセットする。
     */
    const changePostType = () => {
      switch (postType.value) {
        case 'user':
          post.value.type = 'user'
          break
        case 'community':
          post.value.type = 'community'
          break
        default:
          post.value.type = 'none'
          break
      }
    }

    /**
     * Postを作成する。
     * parameterがuserだった場合はpostのtypeをuserとして作成。
     */
    const createPost = async () => {
      changePostType()
      if (post.value.type === 'community') {
        await $axios.post(`/posts?community_id=${selectCommunityName.value}`, { post: post.value, post_image: post.value.postImage })
      }  else {
        await $axios.post('/posts', { post: post.value, post_image: post.value.postImage })
      }
      router.push('/')
    }

    const updatePost = async (postPublic: boolean) => {
      changePostType()
      post.value.status = (postPublic) ? 'public' : 'draft'
      try {
        let response: AxiosResponse<any>
        if (post.value.type === 'community') {
          response = await $axios.put(`/account/posts/${draftQuery.value}?community_id=${selectCommunityName.value}`, { post: post.value, post_image: post.value.postImage })
        } else {
          response = await $axios.put(`/account/posts/${draftQuery.value}`, { post: post.value, post_image: post.value.postImage })
        }
        if (!postPublic) {
          const resPost = response.data.post as PostData
          draftPosts.value = draftPosts.value.filter(p => {
            return p.id !== response.data.post.id
          })
          draftPosts.value.push(resPost)
          draftQuery.value = resPost.id
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
      let response
      changePostType()
      post.value.status = 'draft'
      if (post.value.type === 'community') {
        response = await $axios.post(`/posts?community_id=${selectCommunityName.value}`, { post: post.value, post_image: post.value.postImage })
      } else {
        response = await $axios.post('/posts', { post: post.value, post_image: post.value.postImage })
      }
      const resPost = response.data.post as PostData
      draftPosts.value.push(resPost)
      changePostTyprRouterPush(resPost)
      draftQuery.value = resPost.id
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
      selectMenu,
      clickCreateNewButton,
      selectMenuName,
      createCommunityDialog,
      selectMenuImage,
      tab,
      tabs,
      draftDialog,
      post,
      communities,
      isImageHover,
      draftQuery,
      draftPosts,
      isParameter,
      currentUser,
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
      VueEditor,
      customToolbar,
      community,
      createCommunity,
      communityTypes,
      MAX_COMMUNITY_NAME,
      communityTextLength
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

.v-input--selection-controls {
  margin-top: 8px;
}

::v-deep .v-input--selection-controls__input {
  margin-right: 0 !important;
}

::v-deep .v-dialog {
  transition: initial !important;
}

.v-card__text {
  padding: initial !important;
  color: initial !important;
}

.form {
  max-width: 97%;
  margin-top: 20px;

  .divider {
    margin-bottom: 20px;
  }

  .target-select {
    margin-bottom: 10px;
  }

  .target-select__content {
    content: '';
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
  font-size: 12px;
  color: gray;
}

.select-menu__item-create {
  font-size: 15px;
  color: rgb(16, 124, 248);
}

.select-menu__item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
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

/** Community Create Dialog */
label {
  font-size: 17px;
}

.community-create__radio-text {
  margin-right: 4px;
  color: black;
  font-size: 14px;
}

.community-dialog__subtext {
  font-size: 12px;
  color: #797b7c;
}

.community-create__radio-subtext {
  font-size: 12px;
  color: #797b7c;
}

</style>