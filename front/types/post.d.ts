import { Community } from "./community"
import { UserPost } from "./user"

export type Paths = 'root' | 'hot' | 'new' | 'top'
export type PostType = 'none' | 'user' | 'community'
export type PostStatus = 'draft' | 'public'

export interface Post {
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
  user: UserPost
  community?: Community
}

