module Requests exposing (..)

import Model exposing (..)
import Http exposing (..)
import Task
import Json.Decode as Json exposing (..)

companyList: (Http.Error -> a) -> (List Company -> a) -> Cmd a
companyList errorType successType = 
  let url  = "http://localhost:8901/company"
      request = Http.Request "GET" [] url Http.empty
      send = Http.fromJson decodeCompanies (Http.send Http.defaultSettings request)
  in 
    Task.perform errorType successType <| send

companyAdd : String -> String -> String -> String -> String -> (Http.RawError -> a) -> (Http.Response -> a) -> Cmd a
companyAdd session name lat lon postcode fail succeed = 
  let body = Http.string ("""{"name":"""++toString name++""", "lat": """++lat++""", "lon":"""++lon++""", "postcode":"""++toString postcode++""", "technologies": []}""")
      url  = "http://localhost:8901/company/insert"
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url body
      send = Http.send Http.defaultSettings req 
  in
    Task.perform fail succeed <| send

companyDel : String -> String -> (Http.RawError -> a) -> (Http.Response -> a) -> Cmd a
companyDel session id fail succeed = 
  let url  = "http://localhost:8901/company/delete/" ++ id
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url Http.empty
      send = Http.send Http.defaultSettings req 
  in
    Task.perform fail succeed send


techAdd : String -> (Http.RawError -> a) -> (Http.Response -> a) -> Cmd a
techAdd session fail succeed = 
  let body = Http.string ("""{"name":"javaaa!" """)
      url  = "http://localhost:8901/technology/insert"
      hs   = [ ("Content-Type", "application/json"), ("session", session) ]
      req  = Http.Request "POST" hs url body
      send = Http.send Http.defaultSettings req 
  in
    Task.perform fail succeed <| send

login : String -> String -> (Http.Error -> a) -> (String -> a) -> Cmd a
login u p fail succeed=
  let body = Http.string ("""{"username":"""++toString u++""", "password": """++toString p++""", "email":""}""")
      url  = "http://localhost:8901/login"
      hs   = [ ("Content-Type", "application/json"), ("Accept", "application/json") ]
      req  = Http.Request "POST" hs url body
      send = Http.send Http.defaultSettings req
  in
    Task.perform fail succeed <| Http.fromJson ("session" := Json.string) send

