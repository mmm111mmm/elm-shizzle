module Views.Login exposing (renderLogin)

import Html exposing (Html, div, text, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, style)
import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg(Login), LoginInputData(..))
import String exposing (trim, length)

renderLogin: String -> LoginInputModel -> Html Msg
renderLogin session model =
  if session /= "" then
    div [] []
  else
    div [] [
        div []
            [
              input [ placeholder "username", onInput (Username >> Login) ] []
            ]
        , div []
            [
              input [ placeholder "password", onInput (Password >> Login) ] []
            ]
        , button [ onClick (model |> isPressValid) ] [ text "Login" ]
        , div [ style [ displayNoUserPassMessage model ] ] [ text "Please enter a username and password" ]
        ]

displayNoUserPassMessage : LoginInputModel -> (String,String)
displayNoUserPassMessage model =
  if model.loginPressInvalid && eitherLoginOrPassEmpty model then
    ("display", "block")
  else
    ("display", "none")

isPressValid : LoginInputModel -> Msg
isPressValid model =
  if eitherLoginOrPassEmpty model then
    LoginPressInvalid |> Login
  else
    LoginPress |> Login

eitherLoginOrPassEmpty : LoginInputModel -> Bool
eitherLoginOrPassEmpty model =
  let
    userLength = trim model.username |> length
    passLength = trim model.password |> length
  in
    userLength == 0 || passLength == 0
