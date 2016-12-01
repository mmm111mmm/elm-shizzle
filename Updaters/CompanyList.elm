module Updaters.CompanyList exposing (..)

import Model.Model exposing (..)
import Model.Company exposing (..)
import CompaniesList.CompaniesListModel exposing (..)
import Messages exposing (..)
import Utils exposing (ResponseHttp(..))
import Leaflet

companyListUpdate : CompanyListInputData -> Model -> (Model, Cmd Msg)
companyListUpdate input model =
  let
    companySelectUpdate = model.companySelect
    currentId = companySelectUpdate.id
    next      = findNextCompanyToShow currentId model.companies
    command =
      case input of
        CompanySelect companyId -> Cmd.none
        CompanyNext             -> Leaflet.highlightMarker next
  in
    (model, command)

companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input model =
  let
    updated =
      model.companySelect
  in
    case input of
      Error e         -> ( model, Cmd.none )
      ValueResponse c -> ( model, Leaflet.addLeafletPins (c, updated.id) )

findNextCompanyToShow currentId companies =
  let
    sids = List.sortWith (\c d -> if c.id > d.id then GT else LT ) companies
    ids  = List.filter (\c -> c.id > currentId ) sids
    head = List.head ids
  in
    case head of
      Just v  -> v.id
      Nothing -> case List.head sids of
        Just v  -> v.id
        Nothing -> ""
