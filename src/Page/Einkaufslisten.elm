module Page.Einkaufslisten exposing (view)

import Html exposing (Html, div)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html.Attributes exposing (href)


view : Html msg
view =
    div []
        [ div []
            [ svg [ width "100", height "100" ]
                [ image [ width "100", height "100", href "/SVGs/apple.svg" ] []
                ]
            , svg [ width "100", height "100" ]
                [ image [ width "100", height "100", href "/SVGs/banana.svg" ] []
                ]
            , svg [ width "100", height "100" ]
                [ image [ width "100", height "100", href "/SVGs/carrot.svg" ] []
                ]
            , svg [ width "100", height "100" ]
                [ image [ width "100", height "100", href "/SVGs/tomato.svg" ] []
                ]
            ]
        , svg [ width "100", height "100" ]
            [ image [ width "100", height "100", href "/SVGs/einkaufswagen.svg" ] []
            ]
        ]