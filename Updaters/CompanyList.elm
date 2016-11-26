module Updaters.CompanyList exposing (..)

import Model.Model exposing (..)
import Model.Company exposing (..)
import Messages exposing (..)
import Utils exposing (ResponseHttp(..))
import Leaflet

companyListUpdate : CompanyListInputData -> Model -> (Model, Cmd Msg)
companyListUpdate input model =
  let
    sids = List.sortWith (\c d -> if c.id > d.id then GT else LT ) model.companies
    ids  = List.filter (\c -> c.id > companyListInput.id ) sids
    head = List.head ids
    next =
      case head of
        Just v  -> v.id
        Nothing -> case List.head sids of
          Just v  -> v.id
          Nothing -> ""
    companyListInput = model.companyListInput
    command          = case input of
        CompanySelect companyId -> Cmd.none
        CompanyNext             -> Leaflet.highlightMarker next
    update           = case input of
        CompanySelect companyId -> { companyListInput | id = companyId }
        CompanyNext             -> { companyListInput | id = next }
  in
    ({ model | companyListInput = update }, command)


companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input model =
  let
    companyListInput =
      model.companyListInput
  in
    case input of
      Error e         -> ( model, Cmd.none )
      ValueResponse c -> ( { model | companies = c }, createLeafletPinCommands c companyListInput.id )

createLeafletPinCommands : List Company -> String -> Cmd msg
createLeafletPinCommands companies selected =
  let pins =
    Leaflet.addLeafletPins (companies, selected)
  in
    pins
