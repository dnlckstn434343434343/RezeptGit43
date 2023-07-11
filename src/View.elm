module View exposing (view)

import Recipe_Api
import Html exposing (Html, button, div, h2, img, text, ul)
import Html.Attributes exposing (alt, class, src)
import Html.Events exposing (onClick)
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
        , button [ onClick ToggleAddRecipeForm ] 
            [ text (if model.showAddRecipeForm then "-" else "+") ]
        , if model.showAddRecipeForm then
            Recipe_Api.view model

          else
            text ""
        , h2 [] [ text "Hier sind deine gespeicherten Lieblingsrezepte:" ]
        , ul []
            (List.map viewRecipe model.recipes)
        ]

