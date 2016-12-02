module Main exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (id, style)
import Html.Events exposing (onClick)
import Utils exposing (..)
import Messages exposing (..)
import Model exposing (Model, initModel)
import Requests exposing (fetchCompanies)
import Task

import Leaflet exposing (..)

import Views.Login exposing (renderLogin)
import Views.Company exposing (..)
import Views.CompanyAdd exposing (..)

import Commands exposing (..)
import ModelUpdaters.LoginInputUpdaters exposing (..)
import ModelUpdaters.CompanyInputUpdaters exposing (..)
import ModelUpdaters.CompanySelectUpdaters exposing (..)
import ModelUpdaters.CompaniesListUpdaters exposing (..)
import ModelUpdaters.SessionUpdaters exposing (..)
import ModelUpdaters.TechAddInputUpdaters exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
     _ = Debug.log "msg!" msg
     m = { model |
          session       = sessionUpdaters msg model
          , loginInput      = loginModelUpdaters msg model
          , companyInput  = companyInputModelUpdaters msg model
          , companySelect = companySelectUpdaters msg model
          , companies     = companiesListUpdaters msg model
          , techAddInput = techAddInputUpdaters msg model
         }
  in
    (m, generateCommands msg m)

--

view : Model -> Html Msg
view model =
  let
    -- _ = Debug.log "model" model
    companyIn   = model.companySelect
    loginIn     = model.loginInput
    selected    = companyIn.id
    company     = List.filter (\c -> c.id == selected) model.companies |> List.head
    companyAdd  = model.companyInput
    companyInfo = case company of
      Just c ->
        div [ floatLeft ]
            [ button [ onClick (CompanyNext |> CompanyList) ] [ text "next" ]
              , button [ onClick (CompanyAddShow True |> CompanyAdd) ] [ text "add" ]
              , h5 [] [ text (c.name), delCompany c.id ]
              , div [] [ renderTech model.techAddInput c.technologies c.id ]
            ]
      Nothing ->
        div [ floatLeft ] [text "Try selecting a company"]
    delCompany id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " ×" ]
    companies   = div [] [ div [ id "mapid", floatLeft ] [], companyInfo]
  in
    div []
        [
        div [ style [] ] [ companies ]
        , if loginIn.loginShow then
          div [] [ Utils.popup True (renderLogin model.session loginIn) (LoginShow False |> Login) ]
        else if companyAdd.companyAddShow then
          div [] [ span [] [], Utils.popup True (renderCompanyAdd model) (CompanyAddShow False |> CompanyAdd) ]
        else
          span [] []
        ]

-- Subs and main

init : (Model, Cmd Msg)
init =
  (initModel, Cmd.batch [Leaflet.setupLeaflet True, fetchCompanies])

subscriptions : Model -> Sub Msg
subscriptions model =
  companyClick (CompanySelect >> CompanyList)

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
