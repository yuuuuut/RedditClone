import { Context } from "@nuxt/types";

export default async function (context: Context) {
  console.info('[authenticated.js] store.$auth.loggedIn: ' + context.store.state)
}