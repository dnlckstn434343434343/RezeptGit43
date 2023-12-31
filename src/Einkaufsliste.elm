module Einkaufsliste exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode exposing (Decoder)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Json.Decode exposing (Decoder, succeed)

-- Model

type alias Model =
    { cartItems : List String
    , draggedItem : Maybe String
    }

initialModel : Model
initialModel =
    { cartItems = []
    , draggedItem = Nothing
    }


-- Msg

type Msg
    = DragStart String
    | DragEnd
    | DragEnter
    | DragOver
    | DragLeave
    | Drop


-- Msg Decoders

dropDecoder : Decoder Msg
dropDecoder =
    succeed Drop


-- Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DragStart item ->
            ( { model | draggedItem = Just item }, Cmd.none )

        DragEnd ->
            ( { model | draggedItem = Nothing }, Cmd.none )

        DragEnter ->
            ( model, Cmd.none )

        DragOver ->
            ( model, Cmd.none )

        DragLeave ->
            ( model, Cmd.none )

        Drop ->
            case model.draggedItem of
                Just item ->
                    ( { model | cartItems = item :: model.cartItems, draggedItem = Nothing }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )



-- View

view : Model -> Html Msg
view model =
    div []
        [ div [ Html.Attributes.class "food-items" ]
            (List.map (viewFoodItem model) availableFoodItems)
        , Svg.svg [ Svg.Attributes.class "shopping-cart", Svg.Attributes.viewBox "0 0 100 100" ]
            [ Svg.rect [ Svg.Attributes.width "100", Svg.Attributes.height "100", Svg.Attributes.fill "#f5f5f5" ] []
            , Svg.text_ [ Svg.Attributes.x "50", Svg.Attributes.y "50", Svg.Attributes.textAnchor "middle", Svg.Attributes.fontSize "20", Svg.Attributes.fill "#333" ] [ Html.text "Shopping Cart" ]
            , Svg.text_ [ Svg.Attributes.x "50", Svg.Attributes.y "80", Svg.Attributes.textAnchor "middle", Svg.Attributes.fontSize "14", Svg.Attributes.fill "#666" ] [ Html.text "Drag food items here" ]
            , text_ [ x "50", y "110", textAnchor "middle", fontSize "14", fill "#666" ] (List.map viewCartItem model.cartItems)
            ]
        ]


viewFoodItem : Model -> String -> Html Msg
viewFoodItem _ item =
    let
        _ =
            [ draggable "true"
            , on "dragstart" (Json.Decode.succeed (DragStart item))
            , on "dragend" (Json.Decode.succeed DragEnd)
            ]
    in
    div [ Html.Attributes.class "food-item", draggable "true", on "dragover" (Json.Decode.succeed DragOver), on "dragenter" (Json.Decode.succeed DragEnter), on "dragleave" (Json.Decode.succeed DragLeave), on "drop" (Json.Decode.succeed Drop) ]
        [ img [ src ("./SVGs/" ++ item ++ ".svg"), draggable "false" ] []
        , Html.text item
        ]



viewCartItem : String -> Svg msg
viewCartItem item =
    Html.text item



-- Available Food Items

availableFoodItems : List String
availableFoodItems =
    [ "apple", "banana", "carrot", "tomato" ]


-- Main

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )
