port module Commands.Ports exposing (..)

port companyClick : (String -> msg) -> Sub msg
port focusOnHtml : String -> Cmd msg
port focusOnHtmlId : String -> Cmd msg
