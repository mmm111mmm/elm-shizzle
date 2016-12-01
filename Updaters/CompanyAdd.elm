module Updaters.CompanyAdd exposing (..)

import Model.Model exposing (..)
import Messages exposing (..)
import Requests exposing (addCompany, fetchCompanies)
import Utils exposing (..)

companyAddCommand : CompanyInputData -> Model -> (Model, Cmd Msg)
companyAddCommand input model =
  case input of
    CompanyAddPress -> (model, addCompany model.session model.companyInput)
    _               -> (model, Cmd.none)

companyAddResponseUpdate : ResponseHttp Int -> Model -> (Model, Cmd Msg)
companyAddResponseUpdate input model =
  case input of
    Error e         -> (model, Cmd.none)
    ValueResponse r -> (model, fetchCompanies)
