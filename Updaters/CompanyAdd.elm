module Updaters.CompanyAdd exposing (..)

import Model.Model exposing (Model, CompanyInputModel)
import Messages exposing (Msg, CompanyInputData(..))
import Requests exposing (addCompany, fetchCompanies)
import Utils exposing (..)

companyAddUpdate : CompanyInputData -> Model -> (Model, Cmd Msg)
companyAddUpdate input model =
  let
    companyAddModel =
      model.companyInput
    updatedModel =
      case input of
        Name s     -> { companyAddModel | name = s }
        Lat s      -> { companyAddModel | lat = s }
        Lon s      -> { companyAddModel | lon = s }
        Postcode s -> { companyAddModel | postcode = s }
        _          -> companyAddModel
    command =
      case input of
        CompanyAddPress -> addCompany model.session companyAddModel
        _               -> Cmd.none
  in
    ( { model | companyInput = updatedModel }, command )

companyAddResponseUpdate : ResponseHttp Int -> Model -> (Model, Cmd Msg)
companyAddResponseUpdate input model =
  let companyListInput =
    model.companyListInput
  in
    case input of
      Error e         -> (model, Cmd.none)
      ValueResponse r ->
        let
          updated =
            {companyListInput | id = toString r}
        in
          ({model | companyListInput = updated}, fetchCompanies)
