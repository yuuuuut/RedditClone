import { Module, VuexModule, Mutation } from 'vuex-module-decorators'
import { User as U } from '../models/User'

@Module({ stateFactory: true, namespaced: true, name: 'user' })
export default class User extends VuexModule {
  public user: U | null = null

  @Mutation
  setUser (user: U) {
    this.user = user
  }

  get currentUser () {
    return this.user
  }
}