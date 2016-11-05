module ModelUpdaters exposing (..) 

import Model exposing (..)
import Messages exposing (..)
import Requests exposing (..)
import Utils exposing (..) 


companiesUpdate : ResponseHttp (List Company) -> Model -> (Model, Cmd Msg)
companiesUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse c -> ( { model | companies = c }, Cmd.none ) 


loginUpdate : InputAndResponse (InputAndPress LoginInputData) (ResponseHttp String)
              -> LoginInputModel 
              -> Model 
              -> (Model, Cmd Msg)
loginUpdate input m model =
  case input of
    IR_Input i    -> loginInputUpdate i m model
    IR_Response r -> loginResponseUpdate r model 

loginInputUpdate : InputAndPress LoginInputData -> LoginInputModel -> Model -> (Model, Cmd Msg)
loginInputUpdate input m model =
  case input of
    Input i -> ( loginInputModelUpdate i m model, Cmd.none )
    Press   -> ( model, loginFn m )

loginInputModelUpdate : LoginInputData -> LoginInputModel -> Model -> Model
loginInputModelUpdate input m model =
  let mod =
    case input of
      Username s     -> { m | username = s }
      Password s     -> { m | password = s }
  in 
    { model | loginInput = mod }

loginResponseUpdate : ResponseHttp String -> Model -> (Model, Cmd Msg)
loginResponseUpdate input model =
  case input of
    Error e         -> ( model, Cmd.none )
    ValueResponse s -> ( { model | session = s }, Cmd.none ) 


companyAddUpdate : InputAndResponse (InputAndPress CompanyInputData) RawHttp
                   -> CompanyInputModel 
                   -> Model 
                   -> (Model, Cmd Msg)
companyAddUpdate input m model =
  case input of
    IR_Input i    -> companyInputUpdate i m model
    IR_Response r -> companyAddResponseUpdate r model 

companyInputUpdate : InputAndPress CompanyInputData -> CompanyInputModel -> Model -> (Model, Cmd Msg)
companyInputUpdate input m model =
  case input of
    Input i -> ( companyInputModelUpdate i m model, Cmd.none )
    Press   -> ( model, addCompany model.session model.companyInput )

companyInputModelUpdate : CompanyInputData -> CompanyInputModel -> Model -> Model
companyInputModelUpdate input m model =
  let mod =
    case input of
      Name s         -> { m | name = s }
      Lat s          -> { m | lat = s }
      Lon s          -> { m | lon = s }
      Postcode s     -> { m | postcode = s }
  in 
    { model | companyInput = mod }

companyAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )


companyDelUpdate : InputAndResponse String RawHttp -> Model -> (Model, Cmd Msg)
companyDelUpdate input model =
  case input of
    IR_Input id   -> ( model, delCompany model.session id )
    IR_Response r -> companyDelResponseUpdate r model

companyDelResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
companyDelResponseUpdate input m =
  case input of
    RawError e    -> (m, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (m, fetchCompanies) ) (\_ -> (m, Cmd.none) )


techAddUpdate : InputAndResponse Int RawHttp -> Model -> (Model, Cmd Msg)
techAddUpdate input model =
  case input of
    IR_Input k    -> onEnter k (\_ -> (model, addTech model.session) ) (\_ -> (model, Cmd.none) )
    IR_Response r -> techAddResponseUpdate r model

techAddResponseUpdate : RawHttp -> Model -> (Model, Cmd Msg)
techAddResponseUpdate input model =
  case input of
    RawError e    -> (model, Cmd.none)
    RawResponse r -> httpResponse r (\_ -> (model, fetchCompanies) ) (\_ -> (model, Cmd.none) )
