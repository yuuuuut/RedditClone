import { Community } from "./community"
import { UserPost } from "./user"

export type PostType = 'none' | 'user' | 'community'
export type PostStatus = 'draft' | 'public'

export interface Post {
  id: number
  status: PostStatus
  title: string
  text: string
  url: string
  spoiler: boolean
  nsfw: boolean
  type: PostType
  communityId: string
  createdAt: Date | null
  postImage: {
    uid: string
    url: string
  }
}

export interface PostData {
  user: UserPost
  post: Post
  community?: Community
}

