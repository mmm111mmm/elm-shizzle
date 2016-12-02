module ViewLogin exposing (renderLogin)

import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Model exposing (..)
import Messages exposing (..)
import String exposing (trim, length)
import Utils exposing (..)

renderLogin: String -> LoginInputModel -> Html Msg
renderLogin session model =
  div [] [
      div [] [
        h5 [ style [("display", "inline-block")] ] [ text "Please login"]
      ]
      , div [id "login"] [
        div []
            [
              input [ name "username", placeholder "username", type' "text", onInput (Username >> Login) ] []
            ]
        , div []
            [
              input [ name "password",  placeholder "password", type' "text", onInput (Password >> Login) ] []
            ]
        , button [ onClick (model |> isPressValid) ] [ text "Login" ]
      ]
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
    empty      = userLength == 0 || passLength == 0
  in
    empty
