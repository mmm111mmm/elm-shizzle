port module Commands.Leaflet exposing (..)

import Model exposing (..)

port companyClick : (String -> msg) -> Sub msg
port setupLeaflet : Bool -> Cmd msg
port focusOnHtml : String -> Cmd msg
port focusOnHtmlId : String -> Cmd msg
