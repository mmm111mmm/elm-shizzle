module Views.Company exposing (renderCompany)

import Html exposing (Html, div, text, span, input, p)
import Html.Events exposing (on, keyCode, onClick, onInput)
import Html.Attributes exposing (placeholder, style)
import Model exposing (Company, Technology)
import Messages exposing (Msg(CompanyDel, TechAdd), TechInputData(..))
import Json.Decode as Json

renderCompany : List Company -> Html Msg
renderCompany companies =
  let
    del id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " del" ]
    name c = span [] [ text c.name, del c.id ]
    divider = p [] []
    divs = List.map (\c -> div [] [name c, (renderTech c.technologies), divider]) companies
  in
    div [] divs

renderTech : Maybe (List Technology) -> Html Msg
renderTech ts =
  let
    codeToMsg = Json.map (\i -> i |> TechEnter >> TechAdd) keyCode
    techInput =
      input [
        placeholder "tech"
        , onInput (TechName >> TechAdd)
        , on "keyup" codeToMsg
      ]
      []
    t = case ts of
      Just t  -> List.map (\t -> div [] [text t.name]) t
      Nothing -> [div [] []]
  in
    div [style [("margin-left", "10px")] ] (List.append t [techInput])
