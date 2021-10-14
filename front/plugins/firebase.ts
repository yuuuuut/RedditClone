import { initializeApp, getApps } from "firebase/app"
import { getStorage } from 'firebase/storage'

// eslint-disable-next-line import/no-mutable-exports
let firebaseApp

const firebaseConfig = {
  apiKey: process.env.API_KEY,
  authDomain: process.env.AUTH_DOMAIN,
  projectId: process.env.PROJECT_ID,
  storageBucket: process.env.STORAGE_BUCKET,
  messagingSenderId: process.env.MESSAGING_SENDER_ID,
  appId: process.env.APP_ID
}

const apps = getApps()
if (!apps.length) {
  firebaseApp = initializeApp(firebaseConfig)
} else {
  firebaseApp = apps[0]
}

const storage = getStorage(firebaseApp)

export {
  storage
}