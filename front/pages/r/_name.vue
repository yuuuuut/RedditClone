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
                  r/{{ community.name }}
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
  </div>
</template>

<script lang="ts">
import { useRoute, computed, defineComponent, onMounted, ref } from '@nuxtjs/composition-api'
import { Community } from '~/types/community'
import { $axios } from '~/utils/api'

export default defineComponent({
  setup() {
    const route = useRoute()

    const community = ref<Community>({
      name: '',
      description: '',
      mainImage: '',
      headerImage: '',
      isJoin: false
    })

    const is =  computed(() => {
      return route.value.name === 'r-name'
    })

    onMounted(async () => {
      if (route.value.name !== 'r-name-submit') {
        const response = await $axios.get(`communities/${route.value.params.name}`)
        community.value = response.data.community
      }
    })

    const joinCommunity = async () => {
      try {
        const response = await $axios.post('/account/communities', { community_id: route.value.params.name })
        community.value.isJoin = true
      } catch (e) {
      }
    }

    const leaveCommunity = async () => {
      try {
        const response = await $axios.delete(`/account/communities/${route.value.params.name}`)
        community.value.isJoin = false
      } catch (e) {
      }
    }

    return {
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