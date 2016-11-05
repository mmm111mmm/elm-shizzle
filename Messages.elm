module Messages exposing (..)

import Model exposing (..)
import Utils exposing (..)

type LoginInputData = 
  Username String
  | Password String

type CompanyInputData = 
  Name String
  | Lat String
  | Lon String
  | Postcode String

type Msg = 
  -- login
    LoginInput (InputAndPress LoginInputData)
  | LoginResponse (ResponseHttp String)
  -- company add
  | CompanyInput (InputAndPress CompanyInputData)
  | CompanyAddResponse RawHttp
  -- company list
  | CompanyListResponse (ResponseHttp (List Company))
  -- company del
  | CompanyDel String
  | CompanyDelResponse RawHttp
  -- tech add
  | TechAdd Int
  | TechAddResponse RawHttp
