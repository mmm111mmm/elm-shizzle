module Commands.Commands exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Commands.Requests exposing (..)
import Commands.Leaflet exposing (..)
import Utils exposing (..)
import String exposing (..)

generateCommands input model companySelect =
  let
    command =
      case input of
        Login (LoginPress)                    -> loginFn model.loginInput
        LoginResponse (ValueResponse v)       -> Cmd.none
        LoginResponse (Error _)               -> focusOnHtmlId "#loginUsername"
        --
        CompanyAdd (CompanyAddPress)          -> addCompany model.session model.companyInput
        CompanyAdd (CompanyAddShow True)      -> Cmd.none
        CompanyAddResponse (Error e)          -> Cmd.none
        CompanyAddResponse (ValueResponse r)  -> fetchCompanies
        --
        CompanyDel (CompanyDelConfirmed s)    -> delCompany model.session s
        CompanyDel (CompanyDelShow True)      -> Cmd.none
        CompanyDelResponse (RawError e)       -> Cmd.none
        CompanyDelResponse (RawResponse r)    -> httpResponse1 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
        --
        TechDel id                            -> delTech model.session id
        TechDelResponse (RawError e)          -> Cmd.none
        TechDelResponse (RawResponse r)       -> httpResponse1 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
        --
        CompanyListResponse (Error e)         -> Cmd.none
        CompanyListResponse (ValueResponse c) -> addLeafletPins (c, companySelect.id)
        CompanyList (CompanyNext)             -> highlightMarker <| companySelect.id
        --
        TechAdd (TechEnter 13 id)             -> addTech model.session id model.techAddInput
        TechAdd (TechAddToggle n)             -> if validSession model then focusOnHtmlId "#techAdd" else Cmd.none
        TechAddResponse (RawError e)          -> Cmd.none
        TechAddResponse (RawResponse r)       -> httpResponse1 r (\_ -> fetchCompanies) (\_ -> Cmd.none )
        _                                     -> Cmd.none
    in
      Cmd.batch [ command, highlightMarker <| companySelect.id, focusOnHtml "" ]
