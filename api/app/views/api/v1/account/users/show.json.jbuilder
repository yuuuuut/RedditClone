json.user do
  json.id @user.id
  json.uid @user.uid
  json.uname @user.uname
  json.name @user.name
  json.image @user.image
  json.email @user.email
  json.headerImage 'https://uploads-ssl.webflow.com/5cff83ac2044e22cb8cf2f11/5cffeaf7b3cb0ed2d33f7943_hero.jpg'
  json.isFirstLogin @user.is_first_login

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