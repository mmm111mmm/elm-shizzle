module Messages exposing (..)

import Model.Company exposing (..)
import CompaniesList.CompaniesListModel exposing (..)
import Utils exposing (ResponseHttp, RawHttp)

type LoginInputData =

  Username String
  | Password String
  | LoginPress
  | LoginPressInvalid
  | LoginShow Bool


type CompanyInputData =

  Name String
  | Lat String
  | Lon String
  | Postcode String
  | CompanyAddPress
  | CompanyAddShow Bool

type TechInputData =

  TechAddToggle String
  | TechName String
  | TechEnter Int String

type CompanyListInputData =

  CompanySelect String
  | CompanyNext

type Msg =

  Login LoginInputData
  | LoginResponse (ResponseHttp String)

  | CompanyAdd CompanyInputData
  | CompanyAddResponse (ResponseHttp Int)

  | CompanyDel String
  | CompanyDelResponse RawHttp

  | TechAdd TechInputData
  | TechAddResponse RawHttp

  | TechDel String
  | TechDelResponse RawHttp

  | CompanyList CompanyListInputData
  | CompanyListResponse (ResponseHttp (List Company))
