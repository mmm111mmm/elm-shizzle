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
      Pages msg                 -> pageUpdate msg model

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

pageUpdate msg model =
  case msg of
    LoginPage      -> ( {model | page = "login" }, Cmd.none)
    HomePage       -> ( {model | page = "home" }, Cmd.batch [
      fetchCompanies])
    CompanyAddPage -> ( {model | page = "add" }, Cmd.none)

view : Model -> Html Msg
view model =
  let
    loginVis    = if model.page == "login" then "block" else "none"
    homeVis     = if model.page == "home" then "block" else "none"
    addVis      = if model.page == "add" then "block" else "none"
    --companies  = div [] [renderCompany model.companies, map]
    techAddIn   = model.techAddInput
    companyIn   = model.companyListInput
    selected    = companyIn.id
    company     = List.filter (\c -> c.id == selected) model.companies |> List.head
    companyInfo = case company of
      Just c ->
        div [ floatLeft ]
            [ button [ onClick (CompanyNext |> CompanyList ) ] [ text "next" ]
              , h5 [] [ text (c.name), delCompany c.id ]
              , div [] [ renderTech techAddIn c.technologies c.id ]
            ]
      Nothing ->
        div [ floatLeft ] [text "Try selecting a company"]
    delCompany id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " ×" ]
    companies   = div [] [ div [ id "mapid", floatLeft ] [], companyInfo]
    login       = div [] [ renderLogin model.session model.loginInput ]
    nav         = div [] [
      span [pointy, onClick (HomePage |> Pages)] [text "list"]
      , span [] [text " "]
      , span [pointy, onClick (CompanyAddPage |> Pages)] [text "+"]
    ]
    popup       = div [ style (("background-color", "#000000bb")::("z-index", "500")::centerFlex) ] [
      login
      ]
  in
    div []
        [ nav
        , div [ style [ ("display", loginVis) ] ] [ login ]
        , div [ style [ ("display", addVis) ] ] [ login, renderCompanyAdd model]
        , div [ style [ ("display", homeVis) ] ] [ companies ]
        , popup
        ]


-- Subs and main

init : (Model, Cmd Msg)
init =
  (initModel, Cmd.batch [Task.perform Pages Pages (Task.succeed HomePage), Leaflet.setupLeaflet True])

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
