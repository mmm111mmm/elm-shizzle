module Views.CompanyAdd exposing (renderCompanyAdd)

import Html exposing (Html, div, text, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, type')
import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg(CompanyAdd), CompanyInputData(..))

renderCompanyAdd: Html Msg
renderCompanyAdd =
  div [] [
      div []
          [
            input [ onInput (Name >> CompanyAdd), type' "text", placeholder "name"] []
          ]
      , div []
          [
            input [ onInput (Postcode >> CompanyAdd), type' "text", placeholder "postcode" ] []
         ]
      , button [ onClick (CompanyAddPress |> CompanyAdd), type' "text" ] [ text "Add company" ]
      ]
