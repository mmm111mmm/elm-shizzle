port module Leaflet exposing (..)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPin : (String, String, String, String) -> Cmd msg
port companyClick : (String -> msg) -> Sub msg
port focusOnInput : String -> Cmd msg
