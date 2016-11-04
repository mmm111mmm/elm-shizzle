module Views exposing (..)

import Html exposing (Html, div, text, button, input, p, span)
import Html.Events exposing (on, keyCode, onClick, onInput)
import Html.Attributes exposing (placeholder, style)
import Html.App
import Model exposing (..)
import Messages exposing (..)
import Json.Decode as Json
import Model exposing (..)

view : Model -> Html Msg
view model =  
    div []   
        [  
        renderLogin model.session 
        , p [] [] 
        , renderCompany model.companies 
        , p [] [] 
        , renderCompanyAdd  
        ]  


renderLogin: String -> Html Msg
renderLogin session = 
  if session /= "" then 
    div [] []
  else 
    div [] [
        div []  
            [ 
              input [ placeholder "Username", onInput LoginUsername] []
            ]
        , div []  
            [ 
              input [ placeholder "Password", onInput LoginPassword] []
            ]
        , button [ onClick Login ] [ text "Login" ] 
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
    span [ style [("cursor", "pointer")], onClick (CompanyDel id) ] [ text " del" ]

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
    input [placeholder "tech", ( on "keyup" (Json.map TechAdd keyCode) ) ] []


renderCompanyAdd: Html Msg
renderCompanyAdd = 
  div [] [
      div []  
          [ 
            input [ onInput CompanyName, placeholder "Name"] []
          ]
      , div []  
          [ 
            input [ onInput CompanyLat, placeholder "lat"] []
          ]
      , div []  
          [ 
            input [ onInput CompanyLon, placeholder "lon"] []
          ]
      , div []  
          [ 
            input [ onInput CompanyPostcode, placeholder "postcode"] []
          ]
      , button [ onClick CompanyAdd ] [ text "Add company" ] 
      ]
