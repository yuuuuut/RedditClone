import { Context } from "@nuxt/types"

export default function (context: Context) {
  const isAuthCookie = context.$cookies.get('access-token') || context.$cookies.get('client') || context.$cookies.get('uid')
  const authCookie = context.$cookies.get('auth')

  if (authCookie) {
    const isLogin = authCookie.isLogin
    if (isLogin) {
      const currentUser = context.$cookies.get('auth').user
      context.store.dispatch('user/getCurrentUser', { currentUser, isLogin })
    }
  } else if (isAuthCookie) {
    context.store.dispatch('user/getCurrentUser', { currentUser: null, isLogin: false })
  }
}