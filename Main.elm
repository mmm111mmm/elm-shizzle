module Main exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (id, style)
import Html.Events exposing (onClick)
import Utils exposing (..)
import Messages exposing (..)
import Model.Model exposing (Model, initModel)
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

updateInputResponse : Msg -> Model -> ( Model, Cmd Msg )
updateInputResponse msg model =
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

updateUi : Msg -> (Model, Cmd Msg) -> (Model, Cmd Msg)
updateUi msg modelAndCmd =
  let
    model = fst modelAndCmd
    login = model.loginInput
    companyListInput = model.companyListInput
    companyAdd = model.companyInput
  in
    case msg of
      CompanyAdd (CompanyAddShow True)     ->
        let updatedLogin =
          if model.session == "" then
            { login | loginShow = True }
          else
            { login | loginShow = False }
        in
        ( { model | loginInput = updatedLogin }, snd modelAndCmd )
      Login (LoginShow False)              ->
        let updatedComapanyAdd =
          { companyAdd | companyAddShow = False }
        in
          ( { model | companyInput = updatedComapanyAdd }, snd modelAndCmd )
      CompanyDelResponse (RawResponse r)   ->
        let
          updatedCompanyListInput =
            { companyListInput | id = "" }
        in
          ( {model | companyListInput = updatedCompanyListInput}, snd modelAndCmd )
      _                                    -> modelAndCmd

--

view : Model -> Html Msg
view model =
  let
    -- _ = Debug.log "model" model
    companyIn   = model.companyListInput
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
    , update = \msg model ->
      updateInputResponse msg model |> updateUi msg
    , subscriptions = subscriptions
    }
