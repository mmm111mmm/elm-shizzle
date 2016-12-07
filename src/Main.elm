module Main exposing (..)

import Html.App

import Commands.Ports as Ports
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
        (initModel, Cmd.batch [fetchCompanies])
    , view = \model -> view model model.loginInput model.companyInput model.companySelect model.companyDel
    , update = \msg model ->
        let
           updatedModel = updater msg model
           commands     = generateCommands msg updatedModel updatedModel.companySelect
           _            = Debug.log "message" msg
        in
          ( updatedModel, commands )
    , subscriptions = \_ ->
        Ports.companyClick (CompanySelect >> CompanyList)
    }
