module Updaters.CompanyDel exposing (..)

import Model.Model exposing (Model)
import Messages exposing (Msg(..))
import Requests exposing (delCompany, fetchCompanies)
import Utils exposing (RawHttp(..), httpResponse)

companyDelUpdate : String -> Model -> (Model, Cmd Msg)
companyDelUpdate id model =
  ( model, delCompany model.session id )

companyDelResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyDelResponseUpdate input m =
  case input of
    RawError e    -> (m, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (m, fetchCompanies) ) (\_ -> (m, Cmd.none) )
