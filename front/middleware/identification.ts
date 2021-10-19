import { Context } from "@nuxt/types"
import { userStore } from "~/store"

export default function (context: Context) {
  const currentUser = userStore.currentUser
  if (!currentUser) {
    context.redirect('/')
    return
  }
  if (context.route.params.name !== currentUser.uname) {
    context.redirect('/')
  }
}