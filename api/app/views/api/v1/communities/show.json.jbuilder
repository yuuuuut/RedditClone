json.community do
  json.name @community.name
  json.mainImage @community.main_image
  json.headerImage @community.header_image
  json.description @community.description
  json.path @community.path
  json.isJoin current_user.joined_community?(@community)

  json.posts do
    json.array! @posts do |post|
      json.id post.id
      json.status post.status
      json.title post.title
      json.text post.text
      json.url post.url
      json.spoiler post.spoiler
      json.nsfw post.nsfw
      json.type post.type
      json.communityId post.community_id
      json.postImage do
        json.uid post.post_image.present? ? post.post_image.uid : ''
        json.url post.post_image.present? ? post.post_image.url : ''
      end
      json.user do
        json.id post.user.id
        json.name post.user.name
        json.uname post.user.uname
        json.image post.user.image
      end
      if post.community.present?
        json.community do
          json.name post.community.name
          json.mainImage post.community.main_image
        end
      end
    end
  end
end

json.pagination @pagination