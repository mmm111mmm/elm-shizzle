module Updaters.Login exposing (..)

import Model.Model exposing (Model, LoginInputModel)
import Messages exposing (Msg, LoginInputData(..))
import Requests exposing (loginFn)
import Utils exposing (ResponseHttp(..))

loginUpdate : LoginInputData -> Model -> (Model, Cmd Msg)
loginUpdate input model =
  let
    loginModel  =
      model.loginInput
    updatedModel =
      case input of
        Username s        -> { loginModel | username = s }
        Password s        -> { loginModel | password = s }
        LoginPressInvalid -> { loginModel | loginPressInvalid = True }
        LoginShow b       -> { loginModel | loginShow = b }
        _                 -> loginModel
    command =
      case input of
        LoginPress  -> loginFn loginModel
        _           -> Cmd.none
  in
    ( { model | loginInput = updatedModel }, command)

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
