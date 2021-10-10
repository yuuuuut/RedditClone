import { Module, VuexModule, Mutation } from 'vuex-module-decorators'

export interface UserType {
  uid: string
  image: string
  email: string
}

@Module({ stateFactory: true, namespaced: true, name: 'user' })
export default class User extends VuexModule {
  public user: UserType | null = null

  @Mutation
  setUser (user: UserType) {
    this.user = user
  }

  get currentUser () {
    return this.user
  }
}