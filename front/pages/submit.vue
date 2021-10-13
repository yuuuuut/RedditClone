<template>
  <v-row no-gutters>
    <v-col cols="10">
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
import { $axios } from "~/utils/api"

export default defineComponent({
  setup() {
    const tab = ref(null)
    const tabs = ref(['POST', 'IMAGE', 'LINK'])
    const post = ref({
      title: '',
      text: '',
      url: '',
      spoiler: false,
      nsfw: false,
      status: "public"
    })

    const createPost = async () => {
      const response = await $axios.post('/posts', { post: post.value })
      console.log(response)
    }

    return {
      tab,
      tabs,
      post,
      createPost
    }
  }
})
</script>