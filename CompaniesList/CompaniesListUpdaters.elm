module CompaniesList.CompaniesListUpdaters exposing (..)

import Messages exposing (..)
import CompaniesList.CompaniesListModel exposing (..)
import Utils exposing (..)

companiesListUpdaters msg model
  = companiesListResponse msg

companiesListResponse: Msg -> List Company
companiesListResponse msg =
  case msg of
    CompanyListResponse (Error e)          -> []
    CompanyListResponse (ValueResponse cs) -> cs
    _                                      -> []
