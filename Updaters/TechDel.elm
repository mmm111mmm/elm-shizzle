module Updaters.TechDel exposing (..)

import Model.Model exposing (Model, TechAddInputModel)
import Messages exposing (Msg, TechInputData(..))
import Requests exposing (delTech, fetchCompanies)
import Utils exposing (RawHttp(..), httpResponse)
import String exposing (append, fromChar)
import Char exposing (fromCode)

techDelUpdate : String -> Model -> (Model, Cmd Msg)
techDelUpdate id model =
  ( model, delTech model.session id )

techDelResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techDelResponseUpdate input m =
  case input of
    RawError e    -> (m, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (m, fetchCompanies) ) (\_ -> (m, Cmd.none) )
