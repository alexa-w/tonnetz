module Main exposing (..)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class, style)

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
update _ _ =
    Empty

-- VIEW

view : Model -> Html Msg
view _ =
   div [class "container"] [
        div [class "chord", style "grid-column" "1", style "grid-row" "1"] [
            div [class "major"] []
            , div [class "minor"] []
        ]
   ] 