module ModelUpdaters exposing (..) 

import Model exposing (..)
import Messages exposing (..)
import Requests exposing (..)
import Utils exposing (..) 

loginInputUpdate : LoginInputData -> LoginInputModel -> Model -> Model
loginInputUpdate input m model =
  let mod =
    case input of
      Username s     -> { m | username = s }
      Password s     -> { m | password = s }
  in 
    { model | loginInput = mod }

loginUpdate : ResponseHttp String -> Model -> (Model, Cmd Msg)
loginUpdate input m =
  case input of
    Error e         -> ( m, Cmd.none )
    ValueResponse s -> ( { m | session = s }, Cmd.none ) 


companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input m =
  case input of
    Error e         -> ( m, Cmd.none )
    ValueResponse c -> ( { m | companies = c }, Cmd.none ) 

companyInputUpdate : CompanyInputData -> CompanyInputModel -> Model -> Model
companyInputUpdate input m model =
  let mod =  
    case input of
      Name s         -> { m | name = s }
      Lat s          -> { m | lat = s }
      Lon s          -> { m | lon = s }
      Postcode s     -> { m | postcode = s }
  in
    { model | companyInput = mod }

companyAddUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyAddUpdate input m =
  case input of
    RawError e    -> (m, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (m, fetchCompanies) ) (\_ -> (m, Cmd.none) )


companyDelUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyDelUpdate input m =
  case input of
    RawError e    -> (m, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (m, fetchCompanies) ) (\_ -> (m, Cmd.none) )


techAddUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techAddUpdate input m =
  case input of
    RawError e    -> (m, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (m, Cmd.none) ) (\_ -> (m, Cmd.none) )

