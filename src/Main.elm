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

{-
    PRL transformations described here: https://open.library.okstate.edu/musictheory/chapter/neo-riemannian-triadic-progressions/ 

    The (P)arallel transformation flips the triangle along the edge belonging to the line of perfect fifths (left to right)
    The (R)elative transformation flips the triangle along the edge belonging to the line of major thirds (top left to bottom right)
    The (L)eading-tone transformation flips the triangle along the edge belonging to the line of minor thirds (top right to bottom left)

-}
type Transformation
    = Parallel
    | Relative
    | Leading

-- Position on the grid as X Y pair
type alias Coords
    = (Int, Int)

type Quality
    = Major
    | Minor

-- German note names because it seemed expedient and the thing is called a Tonnetz anyway

type Root
    = A
    | Ais
    | B
    | C
    | Cis
    | D
    | Dis
    | E
    | F
    | Fis
    | G
    | Gis


type Model
    = Chord Quality Root Coords
    | Unset

init : Model
init = Unset

-- UPDATE

type Msg
    = Triad Quality Root Coords
    | Reset

update : Msg -> Model -> Model
update msg _ =
    case msg of
        Triad quality root coords ->
            Chord quality root coords
        _ ->
            Unset

-- VIEW

view : Model -> Html Msg
view _ =
    div [class "container"] [
        div [class "chord", style "grid-column" "1", style "grid-row" "1"] [
            div [class "major"] []
            , div [class "minor"] []
        ]
   ] 