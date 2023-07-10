module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, input, option, select, text, textarea, ul, img)
import Html.Attributes exposing (placeholder, value, alt, src, class)
import Html.Events exposing (onClick, onInput)
import Recipe exposing (viewRecipe)
import Update exposing (Model, Msg(..), initialModel, update)
import Url_Nav


type alias Flags = ()


view : Model -> Html Msg
view model =
    div []
        [ img [ class "img", src "./Bilder/Logo.jpg", alt "Logo" ] []
        , div [ class "container" ]
            [ input [ class "input", placeholder "Name des Rezepts", onInput UpdateNameInput, value model.nameInput ] []
            , textarea [ class "textarea", placeholder "Zutaten", onInput UpdateIngredientsInput, value model.ingredientsInput ] []
            , textarea [ class "textarea", placeholder "Zubereitungsschritte", onInput UpdateStepsInput, value model.stepsInput ] []
            , input [ class "input", placeholder "Zubereitungszeit in Minuten", onInput UpdateTimeInput, value model.timeInput ] []
            , select [ onInput UpdateDifficultyInput ]
                [ option [ value "" ] [ text "Schwierigkeitsgrad wählen" ]
                , option [ value "leicht" ] [ text "leicht" ]
                , option [ value "mittel" ] [ text "mittel" ]
                , option [ value "schwer" ] [ text "schwer" ]
                ]
            , div [] [] -- This is the added div element that creates a blank line
            , select [ onInput UpdateCategoryInput ]
                [ option [ value "" ] [ text "Kategorie wählen" ]
                , option [ value "Frühstück" ] [ text "Frühstück" ]
                , option [ value "Mittagessen" ] [ text "Mittag-/Abendessen" ]
                , option [ value "Mittagessen" ] [ text "Dessert" ]
                , option [ value "Abendessen" ] [ text "Snack" ]
                ]
            , button [ class "button", onClick AddRecipe ] [ text "Rezept speichern" ]
            , h2 [ class "h2"] [ text "Hier sind deine gespeicherten Lieblingsrezepte:" ]
            , ul [] <| List.map viewRecipe model.recipes
            ]
        ]


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

