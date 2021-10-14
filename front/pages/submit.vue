<template>
  <v-row no-gutters>
    <v-col cols="10">
      <v-card class="card">
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
            v-for="(tab, i) in tabs"
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
              <div v-if="tab === 'POST'">
                <v-textarea
                  v-model="post.text"
                  placeholder="Text(optional)"
                  hide-details="auto"
                  outlined
                />
              </div>
              <div v-if="tab === 'IMAGE'">
                <div class="image-area">
                  <div v-if="!postImage.url" class="image-area__inner">
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
                    <img :src="postImage.url" class="image" @mouseover="imageMouseOver" @mouseleave="imageMouseLeave" />
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
              <div v-if="tab === 'LINK'">
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
          <v-chip color="primary" class="mr-3">
            SAVE DRAFT
          </v-chip>
          <v-chip color="black" text-color="white" :disabled="!post.title.length" @click="createPost">
            POST
          </v-chip>
        </div>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts">
import { defineComponent, ref } from "@nuxtjs/composition-api"
import { deleteObject, getDownloadURL, ref as r, uploadBytesResumable } from 'firebase/storage'
import { storage } from "~/plugins/firebase"
import { $axios } from "~/utils/api"

export default defineComponent({
  setup() {
    const tab = ref(null)
    const tabs = ref(['POST', 'IMAGE', 'LINK'])
    const isImageHover = ref(false)
    const post = ref({
      title: '',
      text: '',
      url: '',
      spoiler: false,
      nsfw: false,
      status: "public"
    })
    const postImage = ref({
      uid: '',
      url: ''
    })

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

    const createPost = async () => {
      const response = await $axios.post('/posts', { post: post.value, post_image: postImage.value })
      console.log(response)
    }

    const imageUpload = async (file: Blob) => {
      try {
        postImage.value.url = ''
        postImage.value.uid = ''
        postImage.value.uid = new Date().getTime().toString() + Math.floor(Math.random() * 10).toString()
        const storageRef = r(storage, `images/${postImage.value.uid}`)
        const task = uploadBytesResumable(storageRef, file)
        await task
        const url = await getDownloadURL(storageRef)
        postImage.value.url = url
      } catch (e) {
        console.log(e)
        postImage.value.url = ''
      }
    }

    const deleteImage = async () => {
      const storageRef = r(storage, `images/${postImage.value.uid}`)
      await deleteObject(storageRef)
      postImage.value.uid = ''
      postImage.value.url = ''
    }

    return {
      tab,
      tabs,
      post,
      postImage,
      isImageHover,
      imageMouseOver,
      imageMouseLeave,
      btnclick,
      createPost,
      imageUpload,
      deleteImage
    }
  }
})
</script>

<style lang="scss" scoped>
.card {
  max-width: 90%;
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