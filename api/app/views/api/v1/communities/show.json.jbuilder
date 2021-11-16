json.community do
  json.name @community.name
  json.mainImage @community.main_image
  json.headerImage @community.header_image
  json.description @community.description
  json.path @community.path
  json.isJoin current_user.joined_community?(@community)
end