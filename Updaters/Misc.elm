module Updaters.Misc exposing (..)

import Model.Model exposing (..)
import Messages exposing (..)
import Requests exposing (loginFn)
import Utils exposing (ResponseHttp(..))

loginInputCommand : LoginInputData -> Model -> Cmd Msg
loginInputCommand input model =
  case input of
    LoginPress  -> loginFn model.loginInput
    _           -> Cmd.none

loginResponseUpdate : ResponseHttp String -> Model -> (Model, Cmd Msg)
loginResponseUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse s ->
      ( { model | session = s }, Cmd.none )
