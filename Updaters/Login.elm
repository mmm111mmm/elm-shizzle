module Updaters.Login exposing (..)

import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg, LoginInputData(..))
import Requests exposing (loginFn)
import Utils exposing (ResponseHttp(..))

loginUpdate : LoginInputData -> Model -> (Model, Cmd Msg)
loginUpdate input model =
  let
    login = 
      model.loginInput
    mod   =
      case input of
        Username s        -> { login | username = s }
        Password s        -> { login | password = s }
        LoginPressInvalid -> { login | loginPressInvalid = True }
        _                 -> login
    fn =
      case input of
        LoginPress  -> loginFn model.loginInput
        _           -> Cmd.none
  in
    ( { model | loginInput = login }, fn)

loginResponseUpdate : ResponseHttp String -> Model -> (Model, Cmd Msg)
loginResponseUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse s -> ( { model | session = s }, Cmd.none )
