module Utils exposing (..)

import Http exposing (..)

httpResponse : Http.Response -> (() -> (model, Cmd msg)) -> (() -> (model, Cmd msg)) -> (model, Cmd msg)
httpResponse r success failure =
    if r.status < 300 && r.status >= 200 then
      success ()
    else  
      failure ()

onEnter : Int -> (() -> (a, Cmd b)) -> (() -> (a, Cmd b)) -> (a, Cmd b)
onEnter key enter otherwise =
   if key == 13 then 
     enter ()
   else
     otherwise ()

type RawHttp =
  RawError Http.RawError
  | RawResponse Http.Response
      
type ResponseHttp a =
  Error Http.Error
  | ValueResponse a

