module Updaters.TechAdd exposing (..)

import Model exposing (Model, TechAddInputModel)
import Messages exposing (Msg, TechInputData(..))
import Requests exposing (fetchCompanies, addTech)
import Utils exposing (RawHttp(..), httpResponse)
import String exposing (append, fromChar)
import Char exposing (fromCode)

techAddUpdate : TechInputData -> TechAddInputModel -> Model -> (Model, Cmd Msg)
techAddUpdate key techadd model =
  let
    input =
      case key of
        TechName s -> { techadd | name = s }
        --_  -> { techadd | name = (append (fromCode key |> fromChar) techadd.name) }
  in
    ({ model | techAddInput = input }, Cmd.none)

techAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )
