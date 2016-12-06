module View exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import Utils exposing (..)
import Messages exposing (..)
import Model exposing (..)
import ViewLogin exposing (..)

view model loginInput companyInput companySelect companyDel =
  let
    mainContent =
      div [ style [("display", "flex"), ("flex-direction", "row")] ] [
        div [ id "mapid" ] []
        , span [ style [("padding-left", "8px")] ] [ companyInfoBox model companySelect.id model.techAddInput model.companies]
      ]
  in
    div [] [
      if loginInput.loginShow then
        Utils.popup True (renderLogin model.session loginInput) (LoginShow False |> Login)
      else if companyInput.companyAddShow then
        Utils.popup True (renderCompanyAdd model) (CompanyAddShow False |> CompanyAdd)
      else if companyDel.showBox then
        Utils.popup True (deleteCompanyConfirm companySelect.id) (CompanyDelShow False |> CompanyDel)
      else
        span [] []
      , mainContent
      ]

deleteCompanyConfirm id =
  div [] [ text "Sure you want to delete the company?"
           ,div [] [
             button [ onClick (CompanyDelConfirmed id |> CompanyDel) ] [ text "yup"]
             , button [ onClick (CompanyDelShow False |> CompanyDel)] [ text "neer"]
             ]
          ]


companyInfoBox model selectedId techAddInput companies =
  let
    company     = List.filter (\c -> c.id == selectedId) companies |> List.head
    delCompany id = showOnEdit model <| span [ style [ pointerTuple ], onClick (CompanyDelShow True |> CompanyDel) ] [ text " ×" ]
    buttonBar = div [] [ button [ onClick (CompanyNext |> CompanyList) ] [ text "next" ]
                         , button [ onClick (CompanyAddShow True |> CompanyAdd) ] [ text "add" ] ]
  in
    case company of
      Just c ->
        div [ ]
            [ buttonBar
              , div [] [
                h5 [ style [("display", "inline-block")] ] [ text (c.name) ]
                , delCompany c.id
                , span [ style [ pointerTuple], onClick (CompanyEdit <| not model.companyEdit ) ] [ text " edit" ]
              ]
              , div [] [ renderTech model techAddInput c.technologies c.id ]
            ]
      Nothing ->
        div [ ] [ buttonBar, text "Try selecting a company" ]


showOnEdit model html =
  if model.companyEdit && validSession model then
    html
  else
    span [ style [("visibility", "hidden")] ] [ html ]

renderCompanyAdd : Model -> Html Msg
renderCompanyAdd model =
  div [] [
      h5 [] [text "Add company"]
      , div [id "addCompany"] [
        div []
            [
              input [ id "companyName", class "focus", onInput (Name >> CompanyAdd), type' "text", placeholder "name"] []
            ]
        , div []
            [
              input [ name "companyLat", onInput (Lat >> CompanyAdd), type' "text", placeholder "lat" ] []
           ]
        , div []
            [
              input [ onInput (Lon >> CompanyAdd), type' "text", placeholder "lon" ] []
           ]
        , button [ onClick (CompanyAddPress |> CompanyAdd), type' "text" ] [ text "Add company" ]
       ]
      ]

renderTech : Model -> TechAddInputModel -> Maybe (List Technology) -> String -> Html Msg
renderTech model techAddModel ts companyId =
  let
    codeToMsg          = Json.map (\k -> TechEnter k companyId |> TechAdd) keyCode
    del companyId      = showOnEdit model <| span [ style [("cursor", "pointer")], onClick (companyId |> TechDel) ] [ text " ×" ]
    companyIdAndAddBox = companyId == techAddModel.techAddBox
    showTechAdd        = cssBlockOrNone <| not companyIdAndAddBox || (companyIdAndAddBox && blankSession model)
    showInput          = cssBlockOrNone <| validSession model && companyIdAndAddBox
    techInput techId   =
      div [] [
           input [
             id "techAdd"
             , style [showInput]
             , placeholder "tech?"
             , class "focus"
             , type' "text"
             , onInput (TechName >> TechAdd)
             , on "keyup" codeToMsg
             , value techAddModel.name
           ] [ ]
           , showOnEdit model <| span [
               style [showTechAdd, ("padding", "4px"), ("padding", "4px"), ("font-weight", "bold")]
               , onClick (techId |> TechAddToggle >> TechAdd)
           ] [ text " +" ]
      ]
    technologies = case ts of
      Just t  -> List.map (\t -> span [] [code [] [text t.name], del t.id]) t
      Nothing -> [div [] []]
  in
    div [style [("margin-left", "10px")] ] (List.append technologies [techInput companyId])
