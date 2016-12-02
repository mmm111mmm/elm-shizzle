module Commands.Requests exposing (..)

import Task
import Model exposing (..)
import Http exposing (..)
import Json.Decode as Json exposing (..)
import Messages exposing (..)
import Utils exposing (..)
import Model exposing (..)

companyList: (Http.Error -> a) -> (List Company -> a) -> Cmd a
companyList errorType successType =
  let url  = "http://localhost:8901/company"
      request = Http.Request "GET" [] url Http.empty
      send = Http.fromJson decodeCompanies (Http.send Http.defaultSettings request)
  in
    Task.perform errorType successType <| send

fetchCompanies : Cmd Msg
fetchCompanies = companyList (Error >> CompanyListResponse) (ValueResponse >> CompanyListResponse)


companyAdd : String -> CompanyInputModel -> (Http.Error -> a) -> (Int -> a) -> Cmd a
companyAdd session d fail succeed =
  let body = Http.string ("""{"name":"""++toString d.name++""", "lat": """++d.lat++""", "lon":"""++d.lon++""", "postcode":"""++toString d.postcode++""", "technologies": []}""")
      url  = "http://localhost:8901/company/insert"
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url body
      send = Http.fromJson Json.int (Http.send Http.defaultSettings req)
  in
    Task.perform fail succeed <| send

addCompany : String -> CompanyInputModel -> Cmd Msg
addCompany = \sess input -> companyAdd sess input
  (Error >> CompanyAddResponse)
  (ValueResponse >> CompanyAddResponse)


companyDel : String -> String -> (Http.RawError -> a) -> (Http.Response -> a) -> Cmd a
companyDel session id fail succeed =
  let url  = "http://localhost:8901/company/delete/" ++ id
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url Http.empty
      send = Http.send Http.defaultSettings req
  in
    Task.perform fail succeed send

delCompany : String -> String -> Cmd Msg
delCompany = \sess id -> companyDel sess id
  (RawError >> CompanyDelResponse)
  (RawResponse >> CompanyDelResponse)


techAdd : String -> String -> String -> (Http.RawError -> a) -> (Http.Response -> a) -> Cmd a
techAdd session companyId name fail succeed =
  let body = Http.string ("""{"name":"""++toString name++""", "companyId":""" ++ companyId ++ """}""")
      url  = "http://localhost:8901/company/insert/tech"
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url body
      send = Http.send Http.defaultSettings req
  in
    Task.perform fail succeed <| send

addTech: String -> String -> TechAddInputModel -> Cmd Msg
addTech sess id input =
  techAdd sess id input.name (RawError >> TechAddResponse) (RawResponse >> TechAddResponse)

techDel : String -> String -> (Http.RawError -> a) -> (Http.Response -> a) -> Cmd a
techDel session id fail succeed =
  let url  = "http://localhost:8901/company/delete/tech/" ++ id
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url Http.empty
      send = Http.send Http.defaultSettings req
  in
    Task.perform fail succeed send

delTech : String -> String -> Cmd Msg
delTech = \sess id -> techDel sess id
  (RawError >> TechDelResponse)
  (RawResponse >> TechDelResponse)


login : LoginInputModel -> (Http.Error -> a) -> (String -> a) -> Cmd a
login d fail succeed=
  let body = Http.string ("""{"username":"""++toString d.username++""", "password": """++toString d.password++""", "email":""}""")
      url  = "http://localhost:8901/login"
      hs   = [ ("Content-Type", "application/json"), ("Accept", "application/json") ]
      req  = Http.Request "POST" hs url body
      send = Http.send Http.defaultSettings req
  in
    Task.perform fail succeed <| Http.fromJson ("session" := Json.string) send

loginFn = \input -> login input (Error >> LoginResponse) (ValueResponse >> LoginResponse)
