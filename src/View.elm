module View exposing (view)

import Recipe_Api
import Html exposing (Html, button, div, h2, img, text, ul, a)
import Html.Attributes exposing (alt, class, src, href)
import Html.Events exposing (onClick)
import Recipe exposing (viewRecipe)
import Update exposing (Model, Msg(..))
import Html exposing (input)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)
import Html exposing (textarea)

view : Model -> Html Msg
view model =
    div []
        [ a [ href "/index.html" ]
            [ img [ class "img", src "./Bilder/Logo.jpg", alt "Logo" ] [] ]
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
        , h2 [] [ text "Drücke auf das Plus und füge ein neues Rezept hinzu:" ]
        , button [ onClick ToggleAddRecipeForm ] 
            [ text (if model.showAddRecipeForm then "-" else "+") ]
        , if model.showAddRecipeForm then
            div []
            [ input [ placeholder "Name", onInput UpdateNameInput ] []
            , input [ placeholder "Ingredients", onInput UpdateIngredientsInput ] []
            , textarea [ placeholder "Steps", onInput UpdateStepsInput ] []
            , input [ placeholder "Time", onInput UpdateTimeInput ] []
            , input [ placeholder "Difficulty", onInput UpdateDifficultyInput ] []
            , input [ placeholder "Category", onInput UpdateCategoryInput ] []
            , button [ onClick AddRecipe ] [ text "Add Recipe" ]
            ]
          else
            text ""
        , h2 [] [ text "Hier sind deine gespeicherten Lieblingsrezepte:" ]
        , ul []
            (List.map viewRecipe model.recipes)
        ]
