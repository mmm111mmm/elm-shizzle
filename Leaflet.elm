port module Leaflet exposing (setupLeaflet, addLeafletPin)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPin : (String, String, String) -> Cmd msg
