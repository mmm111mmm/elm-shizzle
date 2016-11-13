port module Leaflet exposing (setupLeaflet, addLeafletPin, companyClick)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPin : (String, String, String, String) -> Cmd msg
port companyClick : (String -> msg) -> Sub msg
