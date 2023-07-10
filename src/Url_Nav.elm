module Url_Nav exposing (init, onUrlChange, onUrlRequest, subscriptions)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Update exposing (Msg(..), Model, initialModel)
import Url


type alias Flags = ()


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( initialModel key, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


onUrlChange : Url.Url -> Msg
onUrlChange url =
    NoOp


onUrlRequest : UrlRequest -> Msg
onUrlRequest urlRequest =
    case urlRequest of
        Internal url ->
            ChangeUrl (Url.toString url)

        External href ->
            NoOp