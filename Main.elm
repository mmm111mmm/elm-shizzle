module Main exposing (..)

import Html exposing (Html, div, p)
import Html.App
import Messages exposing (Msg(..))
import Model exposing (Model, initModel)
import Views exposing (view)
import Requests exposing (fetchCompanies)

import Updaters.Login exposing (loginUpdate, loginResponseUpdate)
import Updaters.CompanyAdd exposing (companyAddUpdate, companyAddResponseUpdate)
import Updaters.CompanyDel exposing (companyDelUpdate, companyDelResponseUpdate)
import Updaters.TechAdd exposing (techAddUpdate, techAddResponseUpdate)
import Updaters.CompanyList exposing (companiesUpdate)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
     _ = Debug.log "msg" msg
  in
    case msg of
      Login msg                 -> loginUpdate msg model.loginInput model
      LoginResponse msg         -> loginResponseUpdate msg model

      CompanyAdd msg            -> companyAddUpdate msg model.companyInput model
      CompanyAddResponse msg    -> companyAddResponseUpdate msg model

      CompanyDel msg            -> companyDelUpdate msg model
      CompanyDelResponse msg    -> companyDelResponseUpdate msg model

      TechAdd msg               -> techAddUpdate msg model
      TechAddResponse msg       -> techAddResponseUpdate msg model

      CompanyListResponse msg   -> companiesUpdate msg model

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
