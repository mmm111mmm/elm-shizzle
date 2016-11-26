module Views.Company exposing (..)

import Html exposing (Html, div, text, span, input, p, form, code, span)
import Html.Events exposing (on, keyCode, onClick, onInput, onBlur)
import Html.Attributes exposing (placeholder, style, type', name)
import Model.Model exposing (..)
import Model.Company exposing (..)
import Messages exposing (Msg(CompanyDel, TechAdd, TechDel), TechInputData(..))
import Json.Decode as Json

--renderCompany : List Company -> Html Msg
--renderCompany companies =
--  let
--    del id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " ×" ]
--    name c = span [] [ text c.name, del c.id ]
--    divider = p [] []
--    divs = List.map (\c -> div [] [name c, (renderTech c.technologies c.id)]) companies
--  in
--    div [] divs

renderTech : TechAddInputModel -> Maybe (List Technology) -> String -> Html Msg
renderTech techAddModel ts companyId =
  let
    _ = Debug.log "model" techAddModel
    codeToMsg        = Json.map (\k -> TechEnter k companyId |> TechAdd) keyCode
    del companyId    = span [ style [("cursor", "pointer")], onClick (companyId |> TechDel) ] [ text " ×" ]
    showTechAdd      = if companyId == techAddModel.techAddBox then ("display","none") else ("display","block")
    showInput        = if companyId == techAddModel.techAddBox then ("display","block") else ("display","none")
    techInput techId =
      div [] [
           input [
             name "techAdd"
             , style [showInput]
             , placeholder "tech"
             , type' "text"
             , onInput (TechName >> TechAdd)
             , on "keyup" codeToMsg
           ] [ ]
           , span [
               style [showTechAdd, ("padding", "4px"), ("padding", "4px"), ("font-weight", "bold")]
               , onClick (techId |> TechAddToggle >> TechAdd)
           ]
           [ text " +" ]
      ]
    technologies = case ts of
      Just t  -> List.map (\t -> span [] [code [] [text t.name], del t.id]) t
      Nothing -> [div [] []]
  in
    div [style [("margin-left", "10px")] ] (List.append technologies [techInput companyId])
