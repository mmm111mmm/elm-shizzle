module Session.SessionUpdaters exposing (..)

import Model.Model exposing (..)
import Messages exposing (..)
import Utils exposing (..)

sessionUpdaters msg model
  = saveSession msg model.session

saveSession: Msg -> String -> String
saveSession msg existing =
  case msg of
    LoginResponse (Error e)         -> existing
    LoginResponse (ValueResponse s) -> s
    _                               -> existing
