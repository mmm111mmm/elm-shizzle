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
  LoginAndResponse (InputAndResponse (InputAndPress LoginInputData) (ResponseHttp String))

  | CompanyAddAndResponse (InputAndResponse (InputAndPress CompanyInputData) RawHttp)

  | CompanyListResponse (ResponseHttp (List Company))

  | CompanyDelAndResponse (InputAndResponse String RawHttp)

  | TechAddAndResponse (InputAndResponse Int RawHttp)
