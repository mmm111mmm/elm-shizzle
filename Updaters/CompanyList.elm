module Updaters.CompanyList exposing (..)

import Model exposing (Model, Company)
import Messages exposing (Msg)
import Utils exposing (ResponseHttp(..))
import Leaflet

companyListUpdate : String -> Model -> (Model, Cmd Msg)
companyListUpdate input model =
  let companyListInput = model.companyListInput
      update           = { companyListInput | id = input}
  in
    ({ model | companyListInput = update }, Cmd.none)


companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse c -> ( { model | companies = c }, createLeafletPinCommands c )

createLeafletPinCommands : List Company -> Cmd msg
createLeafletPinCommands companies =
  Cmd.batch (List.map (\c -> Leaflet.addLeafletPin (c.id, c.name, c.lat, c.lon)) companies)
