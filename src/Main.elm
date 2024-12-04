-- start with elm init
-- elm make src/Main.elm --output elm.js
-- live-server

-- .. means everything is exposed
module Main exposing (..)

-- Import statements
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Array exposing (Array)

-- MAIN

main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }

-- MODEL

type alias Model =
    { array : Array Int
    , index : Int
    , sorted : Bool
    , didSwap : Bool
    }

-- INIT

init : Model
init =
    { array = Array.fromList [9, 5, 3, 1, 6, 7, 10, 2, 4, 8]
    , index = 0
    , sorted = False
    , didSwap = False
    }

-- UPDATE

type Msg
    = Step

update : Msg -> Model -> Model
update Step model =
    -- Don't change the model if it's sorted
    if model.sorted then
        model
    else
        let
            -- Perform one step of bubble sort
            (newArray, swapOccurred) =
                bubbleSortStep model.array model.index

            nextIndex =
                -- Reset to beginning if end of array reached (next pass)
                if model.index >= Array.length model.array - 2 then
                    0
                -- Increment index by 1
                else
                    model.index + 1

            isSorted =
                -- End of array reached and no swaps occured on this pass
                if model.index >= Array.length model.array - 2 then
                    not (model.didSwap || swapOccurred)
                else
                    False

            resetDidSwap =
                -- Reset swap to false if starting new pass
                if model.index >= Array.length model.array - 2 then
                    False
                -- True if previously swapped during pass
                else
                    model.didSwap || swapOccurred
        in
        { model
            | array = newArray
            , index = nextIndex
            , sorted = isSorted
            , didSwap = resetDidSwap
        }

bubbleSortStep : Array Int -> Int -> (Array Int, Bool)
bubbleSortStep array index =
    -- Use case to avoid issues with comparing Maybe Int
    case (Array.get index array, Array.get (index + 1) array) of
        -- Valid Ints to be compared
        (Just a, Just b) ->
            if a > b then
                -- Swap the elements
                let
                    swappedArray =
                        Array.set index b (Array.set (index + 1) a array)
                in
                (swappedArray, True)
            else
                -- No swap needed
                (array, False)

        _ ->
            -- Default case: Do nothing if out of bounds
            (array, False)

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("Array: " ++ (String.join ", " (Array.toList model.array |> List.map String.fromInt))) ]
        , div [] [ text ("Index: " ++ String.fromInt model.index) ]
        , div [] [ text ("Sorted: " ++ stringFromBool model.sorted) ]
        , div [] [ text ("Did Swap: " ++ stringFromBool model.didSwap) ]
        , button [ onClick Step ] [ text "Step" ]
        ]



-- Convert Bool to String value
stringFromBool : Bool -> String
stringFromBool value =
  if value then
    "True"

  else
    "False"