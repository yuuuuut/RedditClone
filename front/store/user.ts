import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators'
import { $axios } from '~/utils/api'

/**
 * Types
 */
export interface UserType {
  uid: string
  image: string
  email: string
}

export type Providers = "Google" | "Twitter"

@Module({ stateFactory: true, namespaced: true, name: 'user' })
export default class User extends VuexModule {
  private user: UserType | null = null

  @Mutation
  setUser (user: UserType | null) {
    this.user = user
  }

  get currentUser () {
    return this.user
  }

  @Action({ rawError: true })
  public async getCurrentUser () {
    const response = await $axios.get('/account/me')
    if (response.status !== 200) {
      this.setUser(null)
      return
    }

    const currentUser = response.data.current_user
    this.setUser(currentUser)
  }

  @Action({ rawError: true })
  public async logout () {
    const response = await $axios.delete('/auth/sign_out')

    if (!response.data.success) {
      return false
    }

    this.setUser(null)
    localStorage.removeItem('access-token')
    localStorage.removeItem('client')
    localStorage.removeItem('uid')
    return true
  }
}