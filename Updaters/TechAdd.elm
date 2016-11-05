module Updaters.TechAdd exposing (..) 

import Model exposing (Model)
import Messages exposing (Msg)
import Requests exposing (fetchCompanies, addTech)
import Utils exposing (RawHttp(..), httpResponse, onEnter) 

techAddUpdate : Int -> Model -> (Model, Cmd Msg)
techAddUpdate key model =
    onEnter key (\_ -> (model, addTech model.session) ) (\_ -> (model, Cmd.none) )

-- response

techAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )
