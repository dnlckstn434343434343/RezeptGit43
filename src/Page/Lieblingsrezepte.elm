module Page.Lieblingsrezepte exposing (view)

import Html exposing (div, input, label, option, select, text)
import Html.Attributes exposing (for, name, placeholder, type_)
import Html exposing (h1)


view : Html.Html msg
view =
    div []
        [ h1[] [text "Speichere hier deine Lieblingsrezepte"]
        , label [ for "recipeName" ] [ text "Name des Rezeptes" ]
        , input [ name "recipeName", placeholder "Name des Rezeptes", type_ "text" ] []
        , label [ for "category" ] [ text "Kategorie" ]
        , select [ name "category" ]
            [ option [] [ text "Frühstück" ]
            , option [] [ text "Mittag-/Abendessen" ]
            , option [] [ text "Dessert/Süßes" ]
            ]
        , label [ for "ingredients" ] [ text "Zutaten" ]
        , input [ name "ingredients", placeholder "Zutaten", type_ "text" ] []
        , label [ for "difficulty" ] [ text "Schwierigkeit" ]
        , select [ name "difficulty" ]
            [ option [] [ text "leicht" ]
            , option [] [ text "mittel" ]
            , option [] [ text "schwer" ]
            ]
        , label [ for "preparationTime" ] [ text "Zubereitungszeit in min." ]
        , input [ name "preparationTime", placeholder "Zubereitungszeit in min.", type_ "number" ] []
        ]

