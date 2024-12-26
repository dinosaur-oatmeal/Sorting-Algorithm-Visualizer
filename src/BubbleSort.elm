module BubbleSort exposing (bubbleSortStep)

import Array exposing (Array)

-- Access to struct needed for program
import Structs exposing (SortingTrack)

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
        length = Array.length arr
    in

    -- Array already sorted
    if track.sorted then
        track
    else
        if nextIndex < length then
            -- Compare current and next element values
            case (Array.get currentIndex arr, Array.get nextIndex arr) of
                (Just currentValue, Just nextValue) ->
                    if currentValue > nextValue then
                        let
                            -- Swap elements in array
                            updatedArray =
                                Array.set currentIndex nextValue (Array.set nextIndex currentValue arr)
                        in
                        -- Update track to reflect new array
                        { track
                            | array = updatedArray
                            , outerIndex = currentIndex + 1
                            , didSwap = True
                            , currentIndex = nextIndex
                        }
                    -- Go to next element in array
                    else
                        { track
                            | outerIndex = currentIndex + 1
                            , didSwap = track.didSwap
                            , currentIndex = nextIndex
                        }

                -- Default constructor
                _ ->
                    track

        -- Go to next pass and update to see if the array is sorted
        else
            let
                -- Determine if array is sorted based on swaps
                isSorted = not track.didSwap
            in
            -- Update track to reflect sorted state
            { track
                | outerIndex = 0
                , currentIndex = 1
                , sorted = isSorted
                , didSwap = False
            }
