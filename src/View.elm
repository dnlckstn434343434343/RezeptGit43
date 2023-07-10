module View exposing (view)

import Html exposing (Html, button, div, h2, input, option, select, text, textarea, ul, img)
import Html.Attributes exposing (placeholder, value, alt, src, class)
import Html.Events exposing (onClick, onInput)
import Recipe exposing (viewRecipe)
import Update exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ img [ class "img", src "./Bilder/Logo.jpg", alt "Logo" ] []
        , div [] [] 
        , div [ class "svg-container" ]
            [ div []
                [ img
                    [ class "svg"
                    , src "./SVGs/breakfast.svg"
                    , onClick (SvgClicked 1)
                    ]
                    []
                , div [class "svg.Unterschrift"] [ text "Frühstück" ]
                ]
            , div []
                [ img
                    [ class "svg"
                    , src "./SVGs/lunch.svg"
                    , onClick (SvgClicked 2)
                    ]
                    []
                , div [class "svg.Unterschrift"] [ text "Mittag-/Abendessen" ]
                ]
            , div []
                [ img
                    [ class "svg"
                    , src "./SVGs/dessert.svg"
                    , onClick (SvgClicked 3)
                    ]
                    []
                , div [class "svg.Unterschrift"] [ text "Dessert/Süßes" ]
                ]
            ]
        , div [] [] 
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
            , div [] [] 
            , select [ onInput UpdateCategoryInput ]
                [ option [ value "" ] [ text "Kategorie wählen" ]
                , option [ value "Frühstück" ] [ text "Frühstück" ]
                , option [ value "Mittagessen" ] [ text "Mittag-/Abendessen" ]
                , option [ value "Dessert/Süßes" ] [ text "Dessert/Süßes" ]
                ]
            , button [ class "button", onClick AddRecipe ] [ text "Rezept speichern" ]
            , h2 [] [ text "Hier sind deine gespeicherten Lieblingsrezepte:" ]
            , ul []
                (List.map viewRecipe model.recipes -- inputs des Users in "Lieblingsezepte" übernehmen 
                    ++ (if model.nameInput /= "" || model.ingredientsInput /= "" 
                    || model.stepsInput /= "" 
                    || model.timeInput /= "" 
                    || model.difficultyInput /= "" 
                    || model.categoryInput /= "" then
                            [{ name = model.nameInput
                             , ingredients = model.ingredientsInput
                             , steps = model.stepsInput
                             , time = model.timeInput
                             , difficulty = model.difficultyInput
                             , category = model.categoryInput
                             }]
                                |> List.map viewRecipe

                        else
                            []
                       )
                )
            ]
        ]


