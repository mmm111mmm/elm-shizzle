module CompanyInput.CompanyInputUpdaters exposing (..)

import Utils exposing (..)
import Messages exposing (..)
import Model.Model exposing (..)
import CompanyInput.CompanyInputModel exposing (..)

companyInputModelUpdaters msg model
  = loginCloseThenCloseCompanyAdd msg model.companyInput
    |> companyAddUpdate msg

loginCloseThenCloseCompanyAdd : Msg -> CompanyInputModel -> CompanyInputModel
loginCloseThenCloseCompanyAdd msg companyInputModel =
  case msg of
    Login (LoginShow False)              -> { companyInputModel | companyAddShow = False }
    CompanyAddResponse (ValueResponse _) -> { companyInputModel | companyAddShow = False }
    _                                    -> companyInputModel

companyAddUpdate : Msg -> CompanyInputModel -> CompanyInputModel
companyAddUpdate msg companyAddModel =
  case msg of
    CompanyAdd (Name s)           -> { companyAddModel | name = s }
    CompanyAdd (Lat s)            -> { companyAddModel | lat = s }
    CompanyAdd (Lon s)            -> { companyAddModel | lon = s }
    CompanyAdd (Postcode s)       -> { companyAddModel | postcode = s }
    CompanyAdd (CompanyAddShow b) -> { companyAddModel | companyAddShow = b }
    _                             -> companyAddModel
