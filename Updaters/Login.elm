module Updaters.Login exposing (..)

import Model.Model exposing (Model, LoginInputModel)
import Messages exposing (..)
import Requests exposing (loginFn)
import Utils exposing (ResponseHttp(..))

loginUserInputUpdate1 : Msg -> LoginInputModel -> LoginInputModel
loginUserInputUpdate1 input loginModel =
  case input of
    Login (Username s)        -> { loginModel | username = s }
    Login (Password s)        -> { loginModel | password = s }
    Login (LoginPressInvalid) -> { loginModel | loginPressInvalid = True }
    Login (LoginShow b)       -> { loginModel | loginShow = b }
    _                 -> loginModel

loginUserInputUpdate : LoginInputData -> Model -> Model
loginUserInputUpdate input model =
  let
    loginInput =
      model.loginInput
    updatedModel =
      case input of
        Username s        -> { loginInput | username = s }
        Password s        -> { loginInput | password = s }
        LoginPressInvalid -> { loginInput | loginPressInvalid = True }
        LoginShow b       -> { loginInput | loginShow = b }
        _                 -> loginInput
  in
    { model | loginInput = updatedModel }

loginCloseThenCloseCompanyAdd: LoginInputData -> Model -> Model
loginCloseThenCloseCompanyAdd input model =
  let
    companyInputModel =
      model.companyInput
    updatedModel =
      case input of
        LoginShow False -> { companyInputModel | companyAddShow = False }
        _               -> companyInputModel
  in
    { model | companyInput = updatedModel }

loginInputCommand : LoginInputData -> Model -> Cmd Msg
loginInputCommand input model =
  case input of
    LoginPress  -> loginFn model.loginInput
    _           -> Cmd.none

loginResponseUpdate : ResponseHttp String -> Model -> (Model, Cmd Msg)
loginResponseUpdate input model =
  let
    loginModel  =
      model.loginInput
    updated =
      { loginModel | loginShow = False}
  in
    case input of
      Error e         -> ( model, Cmd.none )
      ValueResponse s ->
        ( { model | session = s, loginInput = updated }, Cmd.none )
