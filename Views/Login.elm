module Views.Login exposing (renderLogin)

import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, style, type')
import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg(Login), LoginInputData(..))
import String exposing (trim, length)
import Utils exposing (..)

renderLogin: String -> LoginInputModel -> Html Msg
renderLogin session model =
  div [ style [("padding", "20px"),("background", "white")] ] [
      div [] [
        h5 [ style [("display", "inline-block")] ] [ text "Please login"]
        , span [ style [("float", "right"), pointerTuple], onClick (LoginClose |> Login) ] [ text " x" ]
      ]
      , div []
          [
            input [ placeholder "username", type' "text", onInput (Username >> Login) ] []
          ]
      , div []
          [
            input [ placeholder "password", type' "text", onInput (Password >> Login) ] []
          ]
      , button [ onClick (model |> isPressValid) ] [ text "Login" ]
      , div [ style [ displayNoUserPassMessage model ] ] [ text "Please enter a username and password" ]
      , p [] []
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
