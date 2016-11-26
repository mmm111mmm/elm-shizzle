module Messages exposing (..)

import Model.Company exposing (Company)
import Utils exposing (ResponseHttp, RawHttp)

type LoginInputData =

  Username String
  | Password String
  | LoginPress
  | LoginPressInvalid

type CompanyInputData =

  Name String
  | Lat String
  | Lon String
  | Postcode String
  | CompanyAddPress

type TechInputData =

  TechAddToggle String
  | TechName String
  | TechEnter Int String

type CompanyListInputData =

  CompanySelect String
  | CompanyNext

type Msg =

  ShowPopup Bool

  | Login LoginInputData
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
