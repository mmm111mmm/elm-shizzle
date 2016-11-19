port module Leaflet exposing (..)

import Model exposing (..)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPins : List Company -> Cmd msg
port companyClick : (String -> msg) -> Sub msg
port highlightMarker : String -> Cmd msg

port focusOnInput : String -> Cmd msg
