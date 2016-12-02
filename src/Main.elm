module Main exposing (..)

import Html.App

import Commands.Leaflet as Leaflet
import Commands.Commands exposing (..)
import Commands.Requests exposing (..)
import View exposing (..)
import Messages exposing (..)
import Model exposing (..)
import ModelUpdater exposing (..)

main : Program Never
main =
  Html.App.program
    { init =
        (initModel, Cmd.batch [Leaflet.setupLeaflet True, fetchCompanies])
    , view = \model -> view model model.loginInput model.companyInput model.companySelect
    , update = \msg model -> 
        let
           updatedModel = updater msg model
           commands     = generateCommands msg updatedModel
           _            = Debug.log "message" msg
        in
          ( updatedModel, commands )
    , subscriptions = \_ ->
        Leaflet.companyClick (CompanySelect >> CompanyList)
    }
