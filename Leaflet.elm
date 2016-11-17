port module Leaflet exposing (..)

import Model exposing (..)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPin : List Company -> Cmd msg
port companyClick : (String -> msg) -> Sub msg
port focusOnInput : String -> Cmd msg
