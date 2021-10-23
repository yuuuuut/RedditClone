json.community do
  json.id @community.id
  json.name @community.name
  json.mainImage @community.main_image
  json.headerImage @community.header_image
  json.isJoin current_user.joined_community?(@community)
end