<template>
  <v-app>
    <v-app-bar color="white" height="48" app>
      <v-toolbar-title>
        <div @click="a">
          Reddit Clone
        </div>
      </v-toolbar-title>
      <v-text-field
        hide-details
        outlined
        dense
        prepend-inner-icon="mdi-magnify"
        placeholder="Search Reddit"
        class="search-input"
      />
      <v-dialog
        v-model="dialog"
        width="500"
      >
        <v-card>
          <v-card-title class="d-flex justify-space-between">
            <div>
              {{ dialogTitle }}
            </div>
            <v-icon @click="dialog = false">mdi-close</v-icon>
          </v-card-title>
          <v-card-actions class="d-flex flex-column">
            <v-btn
              outlined
              color="primary"
              min-width="300"
              class="mb-3"
              @click="oAuthLogin('Google')"
            >
              <img width="20" height="20" src="/image/google_icon.svg" />
              <div class="pl-4">CONTINUE WITH GOOGLE</div>
            </v-btn>
            <v-btn
              outlined
              color="primary"
              min-width="300"
              class="mb-3"
              @click="oAuthLogin('Twitter')"
            >
              <img width="20" height="20" src="/image/twitter_icon.svg" />
              <div class="pl-4">CONTINUE WITH TWITTER</div>
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <div class="mr-8">
        <template v-if="!isLogin">
          <v-btn
            rounded
            outlined
            color="primary"
            width="120"
            class="mr-5"
            @click="openDialog('LOGIN')"
          >
            Log In
          </v-btn>
          <v-btn
            rounded
            color="primary"
            dark
            width="120"
            class="mr-5"
            @click="openDialog('SIGNUP')"
          >
            Sign Up
          </v-btn>
        </template>
        <template v-if="isLogin">
          <v-icon class="mt-1 mr-4" color="black">mdi-bell-outline</v-icon>
          <NuxtLink to="/submit">
            <v-icon v-bind="attrs" class="mt-1 header-icon" color="black" v-on="on">mdi-plus</v-icon>
          </NuxtLink>
        </template>
        <v-menu
          offset-y
        >
          <!-- eslint-disable-next-line vue/no-template-shadow -->
          <template #activator="{ on, attrs }">
            <v-btn
              dark
              icon
              v-bind="attrs"
              v-on="on"
            >
              <v-icon v-if="!isLogin" color="black">mdi-account-outline</v-icon>
              <div v-if="isLogin && currentUser" class="current-user__header">
                <v-avatar size="30">
                  <img :src="currentUser.image" />
                </v-avatar>
                <div class="current-user__name">{{ currentUser.uname }}</div>
              </div>
              <v-icon color="black">mdi-chevron-down</v-icon>
            </v-btn>
          </template>
          <v-list>
            <NuxtLink v-if="isLogin && currentUser" :to="`user/${currentUser.uname}`">
              <v-list-item>
                <v-list-item-icon>
                  <v-icon>mdi-account</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title>Profile</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </NuxtLink>
            <v-list-item>
              <v-list-item-icon>
                <v-icon>mdi-help-circle</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title>Help</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-divider />
            <v-list-item v-if="!isLogin" @click="openDialog('LOGIN')">
              <v-list-item-icon>
                <v-icon>mdi-login</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title>Login / Sign up</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item v-if="isLogin" @click="logout">
              <v-list-item-icon>
                <v-icon>mdi-logout</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title>Logout</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>
      <v-dialog
        v-if="currentUser"
        v-model="currentUser.isFirstLogin"
        persistent
        max-width="500"
      >
        <v-card>
          <v-card-title class="text-h5">
            Please create an ID
          </v-card-title>
          <div class="pb-7">
            <v-row no-gutters>
              <v-col cols="12" class="px-6 mb-1">
                <v-text-field
                  v-model="uname"
                  outlined
                  width="100%"
                  hide-details="auto"
                  prefix="Own_"
                  counter
                  maxlength="10"
                  :rules="unameRules"
                />
              </v-col>
              <v-col v-if="errors.length" cols="12" class="px-6 mb-1">
                <div v-for="(e, i) in errors" :key="`uname-error-${i}`" style="color: red;">
                  {{ e }}
                </div>
              </v-col>
              <v-col cols="12" class="px-6 mb-5">
                <div>You cannot create an ID that already exists.</div>
              </v-col>
              <v-col cols="12" class="px-6">
                <v-btn
                  color="primary"
                  width="100%"
                  :disabled="isCorrectUname"
                  @click="unameCreate"
                >
                  Create
                </v-btn>
              </v-col>
            </v-row>
          </div>
        </v-card>
      </v-dialog>
    </v-app-bar>
    <v-main ref="r" class="main">
      <Nuxt />
    </v-main>
    <FlashMessage />
  </v-app>
</template>

<script lang="ts">
import {  computed, defineComponent, ref, useRoute, useRouter} from '@nuxtjs/composition-api'
import { userStore } from '@/plugins/store-accessor'
import { Providers } from '~/store/user'
import { $axios } from '~/utils/api'

import FlashMessage from '~/components/FlashMessage.vue'

type dialogType = "LOGIN" | "SIGNUP"

export default defineComponent({
  components: {
    FlashMessage
  },
  setup() {
    const route = useRoute()
    const router = useRouter()
    const pattern = /^[0-9a-zA-Z]*$/

    const r = ref(null)

    const on = ref<any>(null)
    const attrs = ref<any>(null)
    const dialog = ref(false)
    const dialogTitle = ref<string>("")
    const uname = ref('')
    const errors = ref<string[]>([])
    const unameRules = ref([
      (v: string) => {
        return pattern.test(v) || 'Please enter only alphanumeric characters'
      }
    ])

    const isCorrectUname = computed(() => {
      return !uname.value || !pattern.test(uname.value)
    })
    const isLogin = computed(() => {
      return !!userStore.currentUser
    })
    const currentUser = computed(() => {
      return userStore.currentUser
    })

    const unameCreate = async () => {
      try {
        const response = await $axios.patch('/account/users/update_uname', { uname: uname.value })
        if (!response.data) return
        userStore.setUser(response.data.user)
        errors.value = []
      } catch (e) {
        if (e.response.data.status === 422) {
          errors.value.push('This ID is already in use')
        }
      }
    }

    const oAuthLogin = (provider: Providers) => {
      switch (provider) {
        case "Google":
          location.href = 'http://127.0.0.1:3000/api/v1/auth/google_oauth2'
          break
        case "Twitter":
          location.href = 'http://127.0.0.1:3000/api/v1/auth/twitter'
          break
      }
    }

    const openDialog = (type: dialogType) => {
      dialogTitle.value = type === "LOGIN" ? "Login" : "Signup"
      dialog.value = true
    }

    const logout = async () => {
      await userStore.logout()
      router.push('/')
    }

    const a = () => {
        const isRootRoute = route.value.path === '/' ||
                            route.value.path === '/hot' ||
                            route.value.path === '/new' ||
                            route.value.path === '/top'
      if (r.value) {
        (isRootRoute)
          ? r.value.$children[0].$children[0].$children[0].$children[1].pushRouter('root')
          : router.push('/')
      }
    }

    return {
      a,
      r,
      on,
      attrs,
      dialog,
      dialogTitle,
      uname,
      unameRules,
      errors,
      isCorrectUname,
      isLogin,
      currentUser,
      unameCreate,
      openDialog,
      oAuthLogin,
      logout
    }
  }
})
</script>


<style lang="scss">
.v-application p {
  margin-bottom: 0 !important;
}

.v-menu__content {
  box-shadow: initial !important;
  border: 1px solid #dae0e6;
}

.v-overlay {
  transition: initial !important;
}

.v-menu {
  opacity: initial !important;
}

.v-menu-transition-enter-active {
  transition: initial !important;
}

.v-menu-transition-leave-active {
  transition: initial !important;
}

a {
  text-decoration: none;
  color: #000 !important;
}
</style>

<style lang="scss" scoped>
.main {
  background-color: #dae0e6;
}

.v-btn {
  text-transform: initial !important;
}

.v-btn.v-btn + .v-btn {
  margin-left: 0 !important;
}

.v-sheet.v-app-bar.v-toolbar:not(.v-sheet--outlined) {
  box-shadow: initial;
}

.search-input {
  margin-right: 100px;
  margin-left: 150px;
  max-width: 650px;
}

::v-deep .v-input__icon--prepend-inner .v-icon { 
  padding-bottom: 5px;
}

::v-deep .v-text-field .v-input__control .v-input__slot {
  min-height: 34px !important;
}

::v-deep .v-toolbar__content {
  width: 100%;
  display: flex;
  justify-content: space-around;
}

.header-icon {
  margin-right: 80px;
}

.current-user__header {
  min-width: 150px;
  display: flex;

  .current-user__name {
    color: black;
    margin-top: 2px;
    margin-left: 3px;
    font-size: 12px;
  }
}

@media (min-width: 1264px) {
  .container {
    max-width: 1100px;
  }
}
</style>