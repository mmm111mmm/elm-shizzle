module Main exposing (..)

import Html exposing (Html, div, p)
import Html.App
import Requests exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Views exposing (..)
import Http exposing (..)
import Utils exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg m = 
  let _ = Debug.log "msg" msg
      ignore         = (m, Cmd.none)
      onlyFn f       = (m, f)
      onlyModel mo   = (mo, Cmd.none)
      fetchCompanies = companyList CompanyListFetchFail CompanyListFetchSucceed
      addCompany     = companyAdd m.session m.name m.lat m.lon m.postcode CompanyAddNetworkFail CompanyAddResponse 
      delCompany     = \id -> companyDel m.session id CompanyDelFail CompanyDelSucceed
      loginFn        = login m.username m.password LoginFail LoginSucceed
      addTech        = techAdd m.session TechAddNetworkFail TechAddResponse
  in case msg of

    LoginUsername s           -> { m | username = s } |> onlyModel
    LoginPassword s           -> { m | password = s } |> onlyModel
    Login                     -> loginFn |> onlyFn
    LoginFail s               -> ignore
    LoginSucceed s            -> { m | session = s }  |> onlyModel

    CompanyName s             -> { m | name = s }     |> onlyModel
    CompanyLat s              -> { m | lat = s }      |> onlyModel
    CompanyLon s              -> { m | lon = s }      |> onlyModel
    CompanyPostcode s         -> { m | postcode = s } |> onlyModel
    CompanyAdd                -> addCompany |> onlyFn
    CompanyAddNetworkFail _   -> ignore
    CompanyAddResponse r      -> httpResponse r (\_ -> fetchCompanies |> onlyFn) (\_ -> ignore)

    CompanyDel id             -> delCompany id  |> onlyFn
    CompanyDelFail _          -> ignore
    CompanyDelSucceed _       -> fetchCompanies |> onlyFn

    CompanyListFetchFail _    -> ignore
    CompanyListFetchSucceed s -> { m | companies = s } |> onlyModel

    TechAdd k                 -> onEnter k (\_ -> addTech |> onlyFn) (\_ -> ignore )
    TechAddNetworkFail _      -> ignore
    TechAddResponse resp      -> httpResponse resp (\_ -> ignore) (\_ -> ignore) 

-- Subs and main

init : (Model, Cmd Msg)
init = 
  (initModel, companyList CompanyListFetchFail CompanyListFetchSucceed)
    
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
