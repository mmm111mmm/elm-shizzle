module Messages exposing (..)

import Model exposing (..)
import Utils exposing (..)

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

type Msg = 

  Login LoginInputData
  | LoginResponse (ResponseHttp String)

  | CompanyAdd CompanyInputData
  | CompanyAddResponse RawHttp

  | CompanyDel String
  | CompanyDelResponse RawHttp

  | TechAdd Int
  | TechAddResponse RawHttp

  | CompanyListResponse (ResponseHttp (List Company))
