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
                v-model="title"
                placeholder="Title"
                hide-details="auto"
                outlined
                class="mb-2"
              />
              <div v-if="tab === 'POST'">
                <v-textarea
                  placeholder="Text(optional)"
                  hide-details="auto"
                  outlined
                />
              </div>
              <div v-if="tab === 'LINK'">
                <v-text-field
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
            :outlined="!spoiler"
            :color="spoiler ? 'black' : ''"
            :text-color="spoiler ? 'white': ''"
            class="mr-2"
            @click="spoiler = !spoiler"
          >
            <v-icon v-if="!spoiler" left>
              mdi-plus
            </v-icon>
            <v-icon v-else left>
              mdi-check
            </v-icon>
            spoiler
          </v-chip>
          <v-chip
            :outlined="!nsfw"
            :color="nsfw ? 'black' : ''"
            :text-color="nsfw ? 'white': ''"
            @click="nsfw = !nsfw"
          >
            <v-icon v-if="!nsfw" left>
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
          <v-chip color="black" text-color="white" :disabled="!title.length">
            POST
          </v-chip>
        </div>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts">
import { defineComponent, ref } from "@nuxtjs/composition-api"

export default defineComponent({
  setup() {
    const tab = ref(null)
    const tabs = ref(['POST', 'IMAGE', 'LINK'])
    const title = ref('')
    const spoiler = ref(false)
    const nsfw = ref(false)

    return {
      tab,
      tabs,
      title,
      spoiler,
      nsfw
    }
  }
})
</script>