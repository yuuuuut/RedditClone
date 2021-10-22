import { UserPost } from "./user"

export interface Post {
  id: number
  status: 'draft' | 'public'
  title: string
  text: string
  url: string
  spoiler: boolean
  nsfw: boolean
  type: 'none' | 'user' | 'community'
  createdAt: Date | null
  postImage: {
    uid: string
    url: string
  }
}

export interface PostData {
  user: UserPost
  post: Post
}