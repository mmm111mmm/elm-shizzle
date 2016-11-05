module Updaters.CompanyList exposing (..) 

import Model exposing (Model, Company)
import Messages exposing (Msg)
import Utils exposing (ResponseHttp(..)) 

companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse c -> ( { model | companies = c }, Cmd.none ) 
