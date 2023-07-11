module Main exposing (main)

import Browser
import Update exposing (Model, Msg(..), update)
import Url_Nav
import View exposing (view)
import View exposing (view)

type alias Flags = ()


main : Program Flags Model Msg
main =
    Browser.application
        { init = Url_Nav.init
        , view = \model -> 
            { title = "Deine RezeptApp"
            , body = [ view model ]
            }
        , update = update
        , subscriptions = Url_Nav.subscriptions
        , onUrlChange = Url_Nav.onUrlChange
        , onUrlRequest = Url_Nav.onUrlRequest
        }
