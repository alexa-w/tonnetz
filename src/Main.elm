module Main exposing (..)

import Browser
import Html exposing (Html, text)

-- MAIN

main : Program () Model Msg
main = 
    Browser.sandbox 
        { init = init
        , view = view
        , update = update
        }

-- MODEL

type Transformation
    = Parallel
    | Relative
    | Leading

type alias Triad = 
    { quality : String
    , root : String 
    }

type Model
    = Empty
    | Chord Triad

init : Model
init = Empty

-- UPDATE

type Msg
    = Something

update : Msg -> Model -> Model
update msg model =
    Empty

-- VIEW

view : Model -> Html Msg
view model =
    text "placeholder"
