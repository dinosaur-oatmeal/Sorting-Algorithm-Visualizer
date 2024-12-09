module BubbleSort exposing (bubbleSortStep)

import Array exposing (Array)

-- Access to structs needed for program
import Structs exposing (Model, SortingTrack)

{-  Each step compares array[outerIndex] to array[outerIndex + 1]
    If array[outerIndex] > array[outerIndex + 1], swap them
    If no swaps ocurred during a pass, the array is sorted
-}

bubbleSortStep : SortingTrack -> SortingTrack
bubbleSortStep track =
    let
        arr = track.array
        currentIndex = track.outerIndex
        nextIndex = currentIndex + 1
        len = Array.length arr
    in

    -- Array already sorted
    if track.sorted then
        track
    else
        if nextIndex < len then
            -- Compare current and next element values
            case (Array.get currentIndex arr, Array.get nextIndex arr) of
                (Just cv, Just nv) ->
                    if cv > nv then
                        let
                            -- Swap elements and create new array
                            swappedArray =
                                Array.set currentIndex nv (Array.set nextIndex cv arr)
                        in
                        -- Update track to reflect new array
                        { track
                            | array = swappedArray
                            , outerIndex = currentIndex + 1
                            , didSwap = True
                            , compareIndex = nextIndex
                        }
                    -- Go to next element in array
                    else
                        { track
                            | outerIndex = currentIndex + 1
                            , didSwap = track.didSwap
                            , compareIndex = nextIndex
                        }

                -- Default constructor
                _ ->
                    track

        -- Go to next pass and update to see if the array is sorted
        else
            let
                isSorted = not track.didSwap
            in
            { track
                | outerIndex = 0
                , compareIndex = 1
                , sorted = isSorted
                , didSwap = False
            }
