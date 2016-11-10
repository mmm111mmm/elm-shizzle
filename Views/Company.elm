module Views.Company exposing (renderCompany)

import Html exposing (Html, div, text, span, input, p)
import Html.Events exposing (on, keyCode, onClick, onInput)
import Html.Attributes exposing (placeholder, style, type')
import Model exposing (Company, Technology)
import Messages exposing (Msg(CompanyDel, TechAdd, TechDel), TechInputData(..))
import Json.Decode as Json

renderCompany : List Company -> Html Msg
renderCompany companies =
  let
    del id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " ×" ]
    name c = span [] [ text c.name, del c.id ]
    divider = p [] []
    divs = List.map (\c -> div [] [name c, (renderTech c.technologies c.id)]) companies
  in
    div [] divs

renderTech : Maybe (List Technology) -> String -> Html Msg
renderTech ts id =
  let
    codeToMsg = Json.map (\k -> TechEnter k id |> TechAdd) keyCode
    del id = span [ style [("cursor", "pointer")], onClick (id |> TechDel) ] [ text " ×" ]
    techInput =
      input [
        placeholder "tech", type' "text"
        , onInput (TechName >> TechAdd)
        , on "keyup" codeToMsg
      ]
      []
    technologies = case ts of
      Just t  -> List.map (\t -> div [] [text t.name, del t.id]) t
      Nothing -> [div [] []]
  in
    div [style [("margin-left", "10px")] ] (List.append technologies [techInput])
