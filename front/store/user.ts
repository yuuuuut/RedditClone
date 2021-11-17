import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators'
import { $cookies } from '~/utils/cookies'
import { $axios } from '~/utils/api'

/**
 * Types
 */
export interface UserType {
  uid: string
  uname: string
  image: string
  email: string
  name: string
  headerImage: string
  isFirstLogin: boolean
}

export type Providers = "Google" | "Twitter"

@Module({ stateFactory: true, namespaced: true, name: 'user' })
export default class User extends VuexModule {
  private user: UserType | null = null
  private isLogin = false

  @Mutation
  setUser (user: UserType | null) {
    this.user = user
    $cookies.set('auth', { user, isLogin: true })
  }

  @Mutation
  setIsLogin (v: boolean) {
    this.isLogin = v
  }

  @Mutation
  deleteAuth () {
    this.user = null
    this.isLogin = false
    $cookies.remove('access-token')
    $cookies.remove('client')
    $cookies.remove('uid')
    $cookies.remove('auth')
  }

  get currentUser () {
    return this.user
  }

  get isUserLogin () {
    return this.isLogin
  }

  @Action({ rawError: true })
  public async getCurrentUser (payload: { currentUser: UserType | null, isLogin: boolean }) {
    if (payload.isLogin) {
      this.setUser(payload.currentUser)
      this.setIsLogin(true)
    } else {
      const response = await $axios.get('/account/me')
      if (response.status !== 200) {
        this.setUser(null)
        this.setIsLogin(false)
        return
      }

      const currentUser = response.data.current_user
      this.setUser(currentUser)
      this.setIsLogin(true)
    }
  }

  @Action({ rawError: true })
  public async logout () {
    try {
      await $axios.delete('/auth/sign_out')

      this.deleteAuth()
    } catch (e) {
      this.deleteAuth()
    }
  }
}