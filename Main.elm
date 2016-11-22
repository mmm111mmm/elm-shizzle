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

import Updaters.Login exposing (loginUpdate, loginResponseUpdate)
import Updaters.CompanyAdd exposing (companyAddUpdate, companyAddResponseUpdate)
import Updaters.CompanyDel exposing (companyDelUpdate, companyDelResponseUpdate)
import Updaters.TechAdd exposing (techAddUpdate, techAddResponseUpdate)
import Updaters.TechDel exposing (techDelUpdate, techDelResponseUpdate)
import Updaters.CompanyList exposing (companiesUpdate, companyListUpdate)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
     _ = Debug.log "msg!" msg
  in
    case msg of
      Login msg                 -> loginUpdate msg model
      LoginResponse msg         -> loginResponseUpdate msg model

      CompanyAdd msg            -> companyAddUpdate msg model
      CompanyAddResponse msg    -> companyAddResponseUpdate msg model

      CompanyDel msg            -> companyDelUpdate msg model
      CompanyDelResponse msg    -> companyDelResponseUpdate msg model

      TechAdd msg               -> techAddUpdate msg model
      TechAddResponse msg       -> techAddResponseUpdate msg model

      TechDel msg               -> techDelUpdate msg model
      TechDelResponse msg       -> techDelResponseUpdate msg model

      CompanyList msg           -> companyListUpdate msg model
      CompanyListResponse msg   -> companiesUpdate msg model

--

view : Model -> Html Msg
view model =
  let
    _ = Debug.log "model" model
    homeVis     = if model.page == "home" then "block" else "none"
    addVis      = if model.page == "add" then "block" else "none"
    techAddIn   = model.techAddInput
    companyIn   = model.companyListInput
    loginIn     = model.loginInput
    selected    = companyIn.id
    company     = List.filter (\c -> c.id == selected) model.companies |> List.head
    companyInfo = case company of
      Just c ->
        div [ floatLeft ]
            [ button [ onClick (CompanyNext |> CompanyList ) ] [ text "next" ]
              , button [ onClick <| shouldOpenLogin model ] [ text "add" ]
              , h5 [] [ text (c.name), delCompany c.id ]
              , div [] [ renderTech techAddIn c.technologies c.id ]
            ]
      Nothing ->
        div [ floatLeft ] [text "Try selecting a company"]
    delCompany id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " ×" ]
    companies   = div [] [ div [ id "mapid", floatLeft ] [], companyInfo]
    login       = div [] [ renderLogin model.session loginIn ]
    popupDisp   = if loginIn.showLogin || model.page == "showAdd" then ("display", "block") else ("display", "none")
    popup       =
      if model.page == "showAdd" then
        div [ style (popupDisp::("background-color", "#000000bb")::("z-index", "1000")::centerFlex) ] [ renderCompanyAdd model ]
      else
        div [ style (popupDisp::("background-color", "#000000bb")::("z-index", "1000")::centerFlex) ] [ login ]

  in
    div []
        [
        div [ style [ ] ] [ companies ]
        , div [ style [ popupDisp ] ] [ popup ]
        ]

shouldOpenLogin model =
  if model.session == "" then
    LoginOpen |> Login
  else
    CompanyAddShow |> CompanyAdd

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
