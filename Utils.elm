module Utils exposing (..)

import Http
import Html.Attributes exposing (style)

httpResponse : Http.Response -> (() -> (model, Cmd msg)) -> (() -> (model, Cmd msg)) -> (model, Cmd msg)
httpResponse r success failure =
    if r.status < 300 && r.status >= 200 then
      success ()
    else
      failure ()

httpResponse1 : Http.Response -> (() -> a) -> (() -> a) -> a
httpResponse1 r success failure =
    if r.status < 300 && r.status >= 200 then
      success ()
    else
      failure ()


type RawHttp =
  RawError Http.RawError
  | RawResponse Http.Response

type ResponseHttp a =
  Error Http.Error
  | ValueResponse a


pointy      = style [("cursor", "pointer")]
floatLeft   = style [("float", "left"), ("margin-right", "10px")]
centerFlex  = [("display", "flex"), ("flex-direction", "column"), ("justify-content", "center"), ("align-items", "center"), ("height", "100%"), ("width", "100%"), ("position","absolute")]
