module Updaters.TechAdd exposing (..)

import Model.Model exposing (Model, TechAddInputModel)
import Messages exposing (Msg, TechInputData(..))
import Requests exposing (fetchCompanies, addTech)
import Utils exposing (..)
import String exposing (append, fromChar)
import Char exposing (fromCode)
import Leaflet exposing (..)

techAddUpdate : TechInputData -> Model -> (Model, Cmd Msg)
techAddUpdate msg model =
  let
    techAddModel =
      model.techAddInput
    updatedModel =
      case msg of
        TechName s        -> { techAddModel | name = s }
        TechAddToggle num -> { techAddModel | techAddBox = num }
        TechEnter 27 _    -> { techAddModel | techAddBox = "" }
        _                 ->  techAddModel
    command =
      case msg of
        TechEnter 13 id -> addTech model.session id techAddModel
        TechAddToggle n -> if String.length n > 0 then Leaflet.focusOnInput "" else Cmd.none
        _ -> Cmd.none
  in
    ( { model | techAddInput = updatedModel }, command )

techAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techAddResponseUpdate input model =
  let
    techAddModel =
      model.techAddInput
    blankModel =
      { techAddModel | name = "", techAddBox = "" }
    update =
      case input of
        RawResponse r     -> httpResponse1 r (\_ -> blankModel) (\_ -> techAddModel)
        _                 -> techAddModel
  in
    case input of
      RawError e    -> (model, Cmd.none)
      RawResponse r -> httpResponse r
        (\_ -> ({ model | techAddInput = update }, fetchCompanies) )
        (\_ -> ({ model | techAddInput = update }, Cmd.none) )
