module CompanyInput.CompanyInputUpdaters exposing (..)

import Utils exposing (..)
import Messages exposing (..)
import Model.Model exposing (..)
import CompanyInput.CompanyInputModel exposing (..)

companyInputModelUpdaters msg model
  = loginCloseThenCloseCompanyAdd msg model.companyInput

loginCloseThenCloseCompanyAdd: Msg -> CompanyInputModel -> CompanyInputModel
loginCloseThenCloseCompanyAdd input companyInputModel =
  case input of
    Login (LoginShow False) -> { companyInputModel | companyAddShow = False }
    _                       -> companyInputModel
