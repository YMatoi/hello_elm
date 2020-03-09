port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)


port push : String -> Cmd msg


port read : (String -> msg) -> Sub msg


type alias Model =
    { text : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { text = "" }, Cmd.none )


type Msg
    = Push
    | Read String
    | Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change text ->
            ( { model | text = text }, Cmd.none )

        Push ->
            ( model, push model.text )

        Read text ->
            ( { model | text = text }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ input [ value model.text, onInput Change ] []
        , button [ onClick Push ] [ text "Push" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ read Read ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "port sample"
                , body = [ view m ]
                }
        , subscriptions = subscriptions
        }
