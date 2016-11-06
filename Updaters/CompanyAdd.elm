module Updaters.CompanyAdd exposing (..)

import Model exposing (Model, CompanyInputModel)
import Messages exposing (Msg, CompanyInputData(..))
import Requests exposing (addCompany, fetchCompanies)
import Utils exposing (RawHttp(..), httpResponse)

companyAddUpdate : CompanyInputData -> Model -> (Model, Cmd Msg)
companyAddUpdate input model =
  let
    m = model.companyInput
    mod =
      case input of
        Name s     -> { m | name = s }
        Lat s      -> { m | lat = s }
        Lon s      -> { m | lon = s }
        Postcode s -> { m | postcode = s }
        _          -> m
    fn =
      case input of
        CompanyAddPress -> addCompany model.session m
        _               -> Cmd.none
  in
    ( { model | companyInput = mod }, fn )

companyAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )
