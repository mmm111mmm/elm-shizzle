module Updaters.TechAdd exposing (..)

import Model exposing (Model, TechAddInputModel)
import Messages exposing (Msg, TechInputData(..))
import Requests exposing (fetchCompanies, addTech)
import Utils exposing (RawHttp(..), httpResponse)
import String exposing (append, fromChar)
import Char exposing (fromCode)

techAddUpdate : TechInputData -> Model -> (Model, Cmd Msg)
techAddUpdate key model =
  let
    techadd = 
      model.techAddInput
    input =
      case key of
        TechName s  -> { techadd | name = s }
        _ -> techadd
    command =
      case key of
        TechEnter k id -> if k == 13 then
                           addTech model.session id model.techAddInput
                         else
                           Cmd.none
        _ -> Cmd.none
  in
    ({ model | techAddInput = input }, command)

techAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )
