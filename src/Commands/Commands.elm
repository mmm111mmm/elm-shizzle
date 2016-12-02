module Commands.Commands exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Commands.Requests exposing (..)
import Commands.Leaflet as Leaflet 
import Utils exposing (..)
import ModelUpdaters exposing (..)
import String

generateCommands: Msg -> Model -> Cmd Msg
generateCommands input model =
  let selectModel = model.companySelect
  in
    case input of
      Login (LoginPress)                    -> loginFn model.loginInput
      CompanyAdd (CompanyAddPress)          -> addCompany model.session model.companyInput
      CompanyAddResponse (Error e)          -> Cmd.none
      CompanyAddResponse (ValueResponse r)  -> fetchCompanies
      CompanyDel s                          -> delCompany model.session s
      CompanyDelResponse (RawError e)       -> Cmd.none
      CompanyDelResponse (RawResponse r)    -> httpResponse1 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
      TechDel id                            -> delTech model.session id
      TechDelResponse (RawError e)          -> Cmd.none
      TechDelResponse (RawResponse r)       -> httpResponse1 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
      CompanyListResponse (Error e)         -> Cmd.none
      CompanyListResponse (ValueResponse c) -> Leaflet.addLeafletPins (c, selectModel.id)
      CompanyList (CompanyNext)             -> Leaflet.highlightMarker <| findNextCompanyToShow selectModel.id model.companies
      TechAdd (TechEnter 13 id)             -> addTech model.session id model.techAddInput
      TechAdd (TechAddToggle n)             -> if String.length n > 0 then Leaflet.focusOnInput "" else Cmd.none
      TechAddResponse (RawError e)          -> Cmd.none
      TechAddResponse (RawResponse r)       -> httpResponse1 r (\_ -> fetchCompanies) (\_ -> Cmd.none )
      _                                     -> Cmd.none
