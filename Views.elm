module Views exposing (..)

import Html exposing (Html, div, text, button, input, p, span)
import Html.Events exposing (on, keyCode, onClick, onInput)
import Html.Attributes exposing (placeholder, style)
import Html.App
import Model exposing (Model, Company, Technology)
import Messages exposing (Msg(..), CompanyInputData(..))
import Json.Decode as Json

import Views.Login exposing (..)

view : Model -> Html Msg
view model =
    div []
        [
        renderLogin model.session model.loginInput
        , p [] []
        , renderCompany model.companies
        , p [] []
        , renderCompanyAdd
        ]

renderCompany : List Company -> Html Msg
renderCompany companies =
  let
    name = \c -> span [] [ text c.name, renderCompanyDel c.id ]
    divs = List.map (\c -> div [] [name c, (renderTech c.technologies)]) companies
  in
    div [] divs


renderCompanyDel : String -> Html Msg
renderCompanyDel id =
    span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " del" ]

renderTech : Maybe (List Technology) -> Html Msg
renderTech ts =
  let
    t = case ts of
      Just t  -> List.map (\t -> div [] [text t.name]) t
      Nothing -> [div [] []]
    i = renderTech
  in
    div [style [("margin-left", "10px")] ] t


renderTechInput: Html Msg
renderTechInput =
    input [placeholder "tech", ( on "keyup" (Json.map (\i -> i |> TechAdd) keyCode) ) ] []


renderCompanyAdd: Html Msg
renderCompanyAdd =
  div [] [
      div []
          [
            input [ onInput (Name >> CompanyAdd), placeholder "Name"] []
          ]
      , div []
          [
            input [ onInput (Lat >> CompanyAdd), placeholder "lat"] []
          ]
      , div []
          [
            input [ onInput (Lon >> CompanyAdd), placeholder "lon"] []
          ]
      , div []
          [
            input [ onInput (Postcode >> CompanyAdd), placeholder "postcode" ] []
         ]
      , button [ onClick (CompanyAddPress |> CompanyAdd) ] [ text "Add company" ]
      ]
