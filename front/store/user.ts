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
  }

  @Mutation
  setIsLogin (v: boolean) {
    this.isLogin = v
  }

  get currentUser () {
    return this.user
  }

  get isUserLogin () {
    return this.isLogin
  }

  @Action({ rawError: true })
  public async getCurrentUser () {
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

  @Action({ rawError: true })
  public async logout () {
    const response = await $axios.delete('/auth/sign_out')

    if (!response.data.success) {
      return false
    }

    this.setUser(null)
    this.setIsLogin(false)
    $cookies.remove('access-token')
    $cookies.remove('client')
    $cookies.remove('uid')
    return true
  }
}