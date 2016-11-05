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

type InputAndResponse a b =
  IR_Input a
  | IR_Response b

type Msg = 
  -- login
  LoginAndResponse (InputAndResponse (InputAndPress LoginInputData) (ResponseHttp String))
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
