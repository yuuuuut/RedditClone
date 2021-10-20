json.posts do
  json.array! @posts do |p|
    json.id p.id
    json.status p.status
    json.title p.title
    json.text p.text
    json.url p.url
    json.spoiler p.spoiler
    json.nsfw p.nsfw
    json.type p.type
    json.user do
      json.id p.user.id
      json.name p.user.name
      json.uname p.user.uname
    end
    if p.post_image.present?
      json.post_image do
        json.id p.post_image.id
        json.uid p.post_image.uid
        json.url p.post_image.url
      end
    end
  end
end