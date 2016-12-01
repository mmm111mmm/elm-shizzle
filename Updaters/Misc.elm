module Updaters.Misc exposing (..)

import Model.Model exposing (..)
import Messages exposing (..)
import Requests exposing (..)
import Utils exposing (..)

loginInputCommand : Msg -> Model -> Cmd Msg
loginInputCommand input model =
  case input of
    Login (LoginPress) -> loginFn model.loginInput
    CompanyAdd (CompanyAddPress) -> addCompany model.session model.companyInput
    CompanyAddResponse (Error e)         -> Cmd.none
    CompanyAddResponse (ValueResponse r) -> fetchCompanies
    CompanyDel s -> delCompany model.session s
    CompanyDelResponse (RawError e)    -> Cmd.none
    CompanyDelResponse (RawResponse r) -> httpResponse2 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
    TechDel id -> delTech model.session id
    _ -> Cmd.none
