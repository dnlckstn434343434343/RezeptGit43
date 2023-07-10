module Recipe exposing (Recipe, viewRecipe)

import Html exposing (Html, div, text)


type alias Recipe =
    { name : String
    , ingredients : String
    , steps : String
    , time : String
    , difficulty : String
    , category : String
    }


viewRecipe : Recipe -> Html msg
viewRecipe recipe =
    div []
        [ div [] [ text recipe.name ]
        , div [] [ text recipe.ingredients ]
        , div [] [ text recipe.steps ]
        , div [] [ text recipe.time ]
        , div [] [ text recipe.difficulty ]
        , div [] [ text recipe.category ]
        ]
