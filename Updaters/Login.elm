module Updaters.Login exposing (..)

import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg, LoginInputData(..))
import Requests exposing (loginFn)
import Utils exposing (ResponseHttp(..))

loginUpdate : LoginInputData -> LoginInputModel -> Model -> (Model, Cmd Msg)
loginUpdate input m model =
  let
    mod =
      case input of
        Username s        -> { m | username = s }
        Password s        -> { m | password = s }
        LoginPressInvalid -> { m | loginPressInvalid = True }
        _                 -> m
    fn =
      case input of
        LoginPress  -> loginFn model.loginInput
        _           -> Cmd.none
  in
    ( { model | loginInput = mod }, fn)

loginResponseUpdate : ResponseHttp String -> Model -> (Model, Cmd Msg)
loginResponseUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse s -> ( { model | session = s }, Cmd.none )
