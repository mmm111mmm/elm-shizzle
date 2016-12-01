module LoginInput.LoginInputUpdaters exposing (..)

import Utils exposing (..)
import Messages exposing (..)
import Model.Model exposing (..)
import LoginInput.LoginInputModel exposing (..)

loginModelUpdaters msg model
  = loginUserInputUpdate msg model.loginInput
    |> loginSuccessCloseBox msg
    |> loginOpenIfCompanyAddWithNoSession msg model.session

loginUserInputUpdate : Msg -> LoginInputModel -> LoginInputModel
loginUserInputUpdate msg loginModel =
  case msg of
    Login (Username s)        -> { loginModel | username = s }
    Login (Password s)        -> { loginModel | password = s }
    Login (LoginPressInvalid) -> { loginModel | loginPressInvalid = True }
    Login (LoginShow b)       -> { loginModel | loginShow = b }
    _                         -> loginModel

loginSuccessCloseBox : Msg -> LoginInputModel -> LoginInputModel
loginSuccessCloseBox msg loginModel =
  case msg of
    LoginResponse (ValueResponse _) -> { loginModel | loginShow = False }
    _                               -> loginModel

loginOpenIfCompanyAddWithNoSession : Msg -> String -> LoginInputModel -> LoginInputModel
loginOpenIfCompanyAddWithNoSession msg session loginModel =
  case msg of
    CompanyAdd (CompanyAddShow True) -> { loginModel | loginShow = (session == "") }
    _                                 -> loginModel
