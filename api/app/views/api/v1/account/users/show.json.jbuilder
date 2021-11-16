json.user do
  json.id @user.id
  json.uid @user.uid
  json.uname @user.uname
  json.name @user.name
  json.image @user.image
  json.email @user.email
  json.isFirstLogin @user.is_first_login
end