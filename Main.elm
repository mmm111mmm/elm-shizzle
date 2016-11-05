module Main exposing (..)

import Html exposing (Html, div, p)
import Html.App
import Messages exposing (Msg(..))
import Model exposing (Model, initModel)
import ModelUpdaters exposing (loginUpdate, companyAddUpdate, companiesUpdate, companyDelUpdate, techAddUpdate)
import Views exposing (view)
import Requests exposing (fetchCompanies)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
     _ = Debug.log "msg" msg
  in 
    case msg of
      LoginAndResponse msg      -> loginUpdate msg model.loginInput model

      CompanyAddAndResponse msg -> companyAddUpdate msg model.companyInput model

      CompanyListResponse msg   -> companiesUpdate msg model

      CompanyDelAndResponse msg -> companyDelUpdate msg model

      TechAddAndResponse msg    -> techAddUpdate msg model

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
