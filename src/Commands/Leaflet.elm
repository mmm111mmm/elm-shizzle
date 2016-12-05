port module Commands.Leaflet exposing (..)

import Model exposing (..)

port setupLeaflet : Bool -> Cmd msg
port addLeafletPins : (List Company, String)-> Cmd msg
port companyClick : (String -> msg) -> Sub msg
port highlightMarker : String -> Cmd msg
port focusOnHtml : String -> Cmd msg
port focusOnHtmlId : String -> Cmd msg
