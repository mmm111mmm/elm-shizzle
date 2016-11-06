module Messages exposing (..)

import Model exposing (Company)
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

  TechName String

type Msg =

  Login LoginInputData
  | LoginResponse (ResponseHttp String)

  | CompanyAdd CompanyInputData
  | CompanyAddResponse RawHttp

  | CompanyDel String
  | CompanyDelResponse RawHttp

  | TechAdd TechInputData
  | TechAddResponse RawHttp

  | CompanyListResponse (ResponseHttp (List Company))
