module ViewLogin exposing (renderLogin)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Messages exposing (..)
import String exposing (..)
import Utils exposing (..)

renderLogin: String -> LoginInputModel -> Html Msg
renderLogin session model =
  div [ ] [
      div [] [
        h5 [ style [("display", "inline-block")] ] [ text "Please login"]
      ]
      , div [id "login"] [
        div []
            [
              input [ id "loginUsername", class "focus", name "username", placeholder "username", type' "text", onInput (Username >> Login) ] []
            ]
        , div []
            [
              input [ name "password",  placeholder "password", type' "text", onInput (Password >> Login) ] []
            ]
        , span [] [ buttonWithSpinner (model |> isPressValid) "Login" model.loading ]
        , span [] [ text model.errorResponse ]
      ]
      , p [] []
      ]

displayNoUserPassMessage {username, password} =
  if not (username == "" && password == "") && (eitherLoginOrPassEmpty username password) then
    ("display", "block")
  else
    ("display", "none")

isPressValid {username, password} =
  if eitherLoginOrPassEmpty username password then
    LoginPressInvalid |> Login
  else
    LoginPress |> Login

eitherLoginOrPassEmpty username password =
  let
    userLength = trim username |> length
    passLength = trim password |> length
    empty      = userLength == 0 || passLength == 0
  in
    empty
