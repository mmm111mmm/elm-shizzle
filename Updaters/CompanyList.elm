module Updaters.CompanyList exposing (..)

import Model exposing (Model, Company)
import Messages exposing (..)
import Utils exposing (ResponseHttp(..))
import Leaflet

companyListUpdate : CompanyListInputData -> Model -> (Model, Cmd Msg)
companyListUpdate input model =
  let
    companyListInput = model.companyListInput
    update           = case input of
        CompanySelect companyId -> { companyListInput | id = companyId }
        CompanyNext             ->
          let
            ids  = List.filter (\c -> c.id > companyListInput.id ) model.companies
            sor  = List.sortWith (\c d -> if c.id > d.id then GT else LT ) ids
            head = List.head sor
          in
            case head of
              Just v  -> { companyListInput | id = v.id }
              Nothing -> { companyListInput | id = "" }

  in
    ({ model | companyListInput = update }, Cmd.none)


companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse c -> ( { model | companies = c }, createLeafletPinCommands c )

createLeafletPinCommands : List Company -> Cmd msg
createLeafletPinCommands companies =
  let b =
    Leaflet.addLeafletPin companies
  in
    Cmd.batch [b]
