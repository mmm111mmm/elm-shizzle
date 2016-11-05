module Updaters.CompanyAdd exposing (..) 

import Model exposing (Model, CompanyInputModel)
import Messages exposing (Msg, CompanyInputData(..))
import Requests exposing (addCompany, fetchCompanies)
import Utils exposing (RawHttp(..), httpResponse) 

-- input

companyAddUpdate : CompanyInputData -> CompanyInputModel -> Model -> (Model, Cmd Msg)
companyAddUpdate input m model =
  let 
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

-- response

companyAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )
