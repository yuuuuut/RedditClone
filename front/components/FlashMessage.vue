<template>
  <v-alert
    v-if="isFlash"
    dense
    :type="type"
    class="flash-message"
  >
    {{ message }}
  </v-alert>
</template>

<script lang="ts">
import { computed, defineComponent } from "@nuxtjs/composition-api"
import { flashMessageStore } from "~/store"

export default defineComponent({
  setup() {
    const message = computed(() => {
      return flashMessageStore.getMessage
    })
    const isFlash = computed(() => {
      return flashMessageStore.getIsFlash
    })
    const type = computed(() => {
      if (flashMessageStore.getType === 'ERROR') {
        return 'error'
      }
      return 'success'
    })

    return {
      message,
      isFlash,
      type
    }
  }
})
</script>

<style lang="scss" scoped>
.flash-message {
  position: absolute;
  bottom: 1%;
  left: 50%;
  transform: translate(-50%, -1%);
  max-width: 600px;
  z-index: 99999;
}
</style>