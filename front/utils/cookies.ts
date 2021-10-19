import { NuxtCookies } from 'cookie-universal-nuxt'

// eslint-disable-next-line import/no-mutable-exports
let $cookies: NuxtCookies

export function initializeCookies (cookiesInstance: NuxtCookies) {
  $cookies = cookiesInstance
}

export { $cookies }