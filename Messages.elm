module Messages exposing (..)

import Model exposing (..)
import Http exposing (..)

type Msg = 
  -- company list
    CompanyListFetchFail Http.Error 
  | CompanyListFetchSucceed (List Company)
  -- company add
  | CompanyAdd
  | CompanyName String 
  | CompanyLat String 
  | CompanyLon String 
  | CompanyPostcode String 
  | CompanyAddNetworkFail Http.RawError
  | CompanyAddResponse Http.Response
  -- company del
  | CompanyDel String
  | CompanyDelFail Http.RawError
  | CompanyDelSucceed Http.Response
  -- tech add
  | TechAdd Int
  | TechAddNetworkFail Http.RawError
  | TechAddResponse Http.Response
  -- login
  | Login
  | LoginUsername String
  | LoginPassword String
  | LoginFail Http.Error
  | LoginSucceed String




