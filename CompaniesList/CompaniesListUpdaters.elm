module CompaniesList.CompaniesListUpdaters exposing (..)

import Messages exposing (..)
import CompaniesList.CompaniesListModel exposing (..)
import Utils exposing (..)

companiesListUpdaters msg model
  = companiesListResponse msg model.companies

companiesListResponse: Msg -> List Company -> List Company
companiesListResponse msg existing =
  case msg of
    CompanyListResponse (Error e)          -> existing
    CompanyListResponse (ValueResponse cs) -> cs
    _                                      -> existing
