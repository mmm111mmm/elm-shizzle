port module Leaflet exposing (..)

import ModelUpdaters.CompaniesListModel exposing (..)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPins : (List Company, String)-> Cmd msg
port companyClick : (String -> msg) -> Sub msg
port highlightMarker : String -> Cmd msg
port focusOnInput : String -> Cmd msg
