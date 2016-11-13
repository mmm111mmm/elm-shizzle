module Main exposing (..)

import Html.App
import Html exposing (Html, div, p, text, hr, span)
import Html.Attributes exposing (id, style)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model, initModel)
import Requests exposing (fetchCompanies)
import Task

import Leaflet exposing (..)

import Views.Login exposing (renderLogin)
import Views.Company exposing (renderCompany)
import Views.CompanyAdd exposing (renderCompanyAdd)

import Updaters.Login exposing (loginUpdate, loginResponseUpdate)
import Updaters.CompanyAdd exposing (companyAddUpdate, companyAddResponseUpdate)
import Updaters.CompanyDel exposing (companyDelUpdate, companyDelResponseUpdate)
import Updaters.TechAdd exposing (techAddUpdate, techAddResponseUpdate)
import Updaters.TechDel exposing (techDelUpdate, techDelResponseUpdate)
import Updaters.CompanyList exposing (companiesUpdate)

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
    loginVis   = if model.page == "login" then "block" else "none"
    homeVis    = if model.page == "home" then "block" else "none"
    addVis     = if model.page == "add" then "block" else "none"
    pointy     = style [("cursor", "pointer")]
    floatLeft  = style [("float", "left"), ("margin-right", "10px")]
    --companies  = div [] [renderCompany model.companies, map]
    companies  = div [] [map]
    map        = div [id "mapid", floatLeft ] []
    login      = div [] [renderLogin model.session model.loginInput]
    nav        = div [] [
      span [pointy, onClick (HomePage |> Pages)] [text "home"]
      , span [] [text " | "]
      , span [pointy, onClick (LoginPage |> Pages)] [text "login"]
      , span [] [text " | "]
      , span [pointy, onClick (CompanyAddPage |> Pages)] [text "add"]
    ]
  in
    div []
        [ nav
        , div [ style [ ("display", loginVis) ] ] [ login ]
        , div [ style [ ("display", addVis) ] ] [ renderCompanyAdd ]
        , div [ style [ ("display", homeVis) ] ] [ companies ]
        ]


-- Subs and main

init : (Model, Cmd Msg)
init =
  (initModel, Cmd.batch [Task.perform Pages Pages (Task.succeed HomePage), Leaflet.setupLeaflet True])

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
