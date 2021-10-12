json.current_user do
  json.id current_user.id
  json.uid current_user.uid
  json.name current_user.name
  json.image current_user.image
  json.email current_user.email
end