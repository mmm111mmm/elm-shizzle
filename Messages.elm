module Messages exposing (..)

import Model exposing (Company)
import Utils exposing (ResponseHttp, RawHttp)

type LoginInputData =

  Username String
  | Password String
  | LoginPress
  | LoginPressInvalid

type Pages =

  LoginPage
  | CompanyAddPage
  | HomePage


type CompanyInputData =

  Name String
  | Lat String
  | Lon String
  | Postcode String
  | CompanyAddPress

type TechInputData =

  TechName String
  | TechEnter Int String

type Msg =

  Pages Pages

  | Login LoginInputData
  | LoginResponse (ResponseHttp String)

  | CompanyAdd CompanyInputData
  | CompanyAddResponse RawHttp

  | CompanyDel String
  | CompanyDelResponse RawHttp

  | TechAdd TechInputData
  | TechAddResponse RawHttp

  | TechDel String
  | TechDelResponse RawHttp

  | CompanyList String
  | CompanyListResponse (ResponseHttp (List Company))
