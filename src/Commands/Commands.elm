module Commands.Commands exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Commands.Requests exposing (..)
import Commands.Leaflet exposing (..)
import Utils exposing (..)
import String exposing (..)

generateCommands: Msg -> Model -> Cmd Msg
generateCommands input model =
  let
    selectModel = model.companySelect
    command =
      case input of
        Login (LoginPress)                    -> loginFn model.loginInput
        LoginResponse (ValueResponse v)       -> focusOnHtml "#companyName"
        --
        CompanyAdd (CompanyAddPress)          -> addCompany model.session model.companyInput
        CompanyAdd (CompanyAddShow True)      -> if blankSession model then focusOnHtml "#loginUsername" else Cmd.none
        CompanyAddResponse (Error e)          -> Cmd.none
        CompanyAddResponse (ValueResponse r)  -> fetchCompanies
        --
        CompanyDel s                          -> delCompany model.session s
        CompanyDelResponse (RawError e)       -> Cmd.none
        CompanyDelResponse (RawResponse r)    -> httpResponse1 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
        --
        TechDel id                            -> delTech model.session id
        TechDelResponse (RawError e)          -> Cmd.none
        TechDelResponse (RawResponse r)       -> httpResponse1 r (\_ -> fetchCompanies ) (\_ -> Cmd.none )
        --
        CompanyListResponse (Error e)         -> Cmd.none
        CompanyListResponse (ValueResponse c) -> addLeafletPins (c, selectModel.id)
        CompanyList (CompanyNext)             -> highlightMarker <| selectModel.id
        --
        TechAdd (TechEnter 13 id)             -> addTech model.session id model.techAddInput
        TechAdd (TechAddToggle n)             -> if length n > 0 then focusOnHtml "#techAdd" else Cmd.none
        TechAddResponse (RawError e)          -> Cmd.none
        TechAddResponse (RawResponse r)       -> httpResponse1 r (\_ -> fetchCompanies) (\_ -> Cmd.none )
        _                                     -> Cmd.none
    in
      Cmd.batch [command, highlightMarker <| selectModel.id ]
