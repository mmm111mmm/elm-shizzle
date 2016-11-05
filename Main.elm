module Main exposing (..)

import Html exposing (Html, div, p)
import Html.App
import Http exposing (..)
import Utils exposing (..)
import Messages exposing (..)
import Model exposing (..)
import ModelUpdaters exposing (..)
import Requests exposing (..)
import Views exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg m = 
  let _ = Debug.log "msg" msg
      ignore         = (m, Cmd.none)
      onlyFn f       = (m, f)
      onlyModel mo   = (mo, Cmd.none)
  
  in case msg of
    LoginInput input          -> loginInputUpdate input m.loginInput m |> onlyModel
    LoginPress                -> loginFn m.loginInput |> onlyFn
    LoginResponse resp        -> loginUpdate resp m

    CompanyInput input        -> companyInputUpdate input m.companyInput m |> onlyModel
    CompanyAddPress           -> addCompany m.session m.companyInput |> onlyFn
    CompanyAddResponse resp   -> companyAddUpdate resp m

    CompanyListResponse resp  -> companiesUpdate resp m

    CompanyDel id             -> delCompany m.session id  |> onlyFn
    CompanyDelResponse resp   -> companyDelUpdate resp m

    TechAdd k                 -> onEnter k (\_ -> addTech m.session |> onlyFn) (\_ -> ignore)
    TechAddResponse resp      -> techAddUpdate resp m

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
