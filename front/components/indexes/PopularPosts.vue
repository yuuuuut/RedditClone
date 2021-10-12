<template>
  <v-col ref="root" cols="8" style="background-color: #FFCDD2">
    Popular posts
    <div class="a">
      <v-card class="card" outlined>
        <div class="d-flex">
          <div style="width: 10%; background: green;">
            a
          </div>
          <div style="width: 90%; background: blue;">
            <div class="d-flex justify-space-between">
              <div class="d-flex">
                <v-avatar
                  color="primary"
                  size="19"
                ></v-avatar>
                <div>test name</div>
                <div>Posted byu/MeruMSB 6 months ago</div>
              </div>
              <div>
                <div>Join</div>
              </div>
            </div>
            <div>
              本文
            </div>
          </div>
        </div>
      </v-card>
      <v-card class="card" outlined></v-card>
    </div>
  </v-col>
</template>

<script lang="ts">
import { defineComponent, onMounted, onUnmounted, ref } from '@vue/composition-api'

export default defineComponent({
  setup() {
    const root = ref(null)

    onMounted(() => {
      window.addEventListener("scroll", handleScroll)
    })

    onUnmounted(() => {
      window.removeEventListener("scroll", handleScroll)
    })

    const handleScroll = () => {
      const elm = root.value
      if (elm.getBoundingClientRect().bottom < window.innerHeight) {
        console.log('OK')
      }
      console.log(root.value.getBoundingClientRect())
    }

    return {
      root
    }
  }
})
</script>

<style lang="scss" scoped>
.a {
  width: 97%;
  background-color: red;
}

.card {
  height: 500px;
}
</style>