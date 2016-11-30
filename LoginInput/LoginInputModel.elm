module LoginInput.LoginInputModel exposing (..)

type alias LoginInputModel = {
  username : String
  , password : String
  , loginPressInvalid: Bool
  , loginShow: Bool
}

initLoginInputModel = LoginInputModel "" "" False False
