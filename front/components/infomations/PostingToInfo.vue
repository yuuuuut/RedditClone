<template>
  <v-card class="card">
    <div>
      <h4 class="mb-2">Posting to Reddit</h4>
    </div>
    <v-divider />
    <div>
      <div v-for="(i, idx) in infomations" :key="idx">
        <div class="info-item">{{ idx + 1 }}.{{ i.text }}</div>
        <v-divider />
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { defineComponent, ref } from "@nuxtjs/composition-api"

export default defineComponent({
  setup() {
    const infomations = ref([
      { text: 'Remember the human' },
      { text: 'Behave like you would in real life' },
      { text: 'Look for the original source of content' },
      { text: 'Search for duplicates before posting' },
      { text: 'Read the community’s rules' }
    ])

    return {
      infomations
    }
  }
})
</script>

<style lang="scss" scoped>
.card {
  max-width: 90%;
  margin-bottom: 20px;
  padding: 16px;
}

.info-item {
  margin: 10px 5px;
  font-size: 14px;
}
</style>