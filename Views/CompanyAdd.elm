module Views.CompanyAdd exposing (renderCompanyAdd)

import Html exposing (Html, div, text, button, input, span)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, type')
import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg(CompanyAdd), CompanyInputData(..))

renderCompanyAdd : Model -> Html Msg
renderCompanyAdd model =
  if model.session == "" then
    span [] []
  else
    div [] [
        div []
            [
              input [ onInput (Name >> CompanyAdd), type' "text", placeholder "name"] []
            ]
        , div []
            [
              input [ onInput (Lat >> CompanyAdd), type' "text", placeholder "lat" ] []
           ]
        , div []
            [
              input [ onInput (Lon >> CompanyAdd), type' "text", placeholder "lon" ] []
           ]
        , button [ onClick (CompanyAddPress |> CompanyAdd), type' "text" ] [ text "Add company" ]
        ]
