json.user do
  json.id current_user.id
  json.uid current_user.uid
  json.uname current_user.uname
  json.name current_user.name
  json.image current_user.image
  json.email current_user.email
  json.isFirstLogin current_user.is_first_login
end