module Main exposing (..)

import Html.App
import Html exposing (Html, div, p, text)
import Messages exposing (Msg(..))
import Model exposing (Model, initModel)
import Requests exposing (fetchCompanies)

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

view : Model -> Html Msg
view model =
    div []
        [
        renderLogin model.session model.loginInput
        , p [] []
        , renderCompany model.companies
        , p [] []
        , renderCompanyAdd
        ]


-- Subs and main

init : (Model, Cmd Msg)
init =
  (initModel, fetchCompanies)

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
