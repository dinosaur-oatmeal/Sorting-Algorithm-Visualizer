module InsertionSort exposing (insertionSortStep)

import Array exposing (Array)

-- Access to structs needed for program
import Structs exposing (Model, SortingTrack)


{-  Take element at outerIndex and move it into sorted position of array
    Each step, compare array[comparIndex] with array[currentIndex + 1]
    If they're out of order, swap them and move currentIndex back once toward beginning of array
    Once in order or beginning hit, insert the element and move outerIndex right once
-}

insertionSortStep : SortingTrack -> SortingTrack
insertionSortStep track =
    let
        arr = track.array
        outer = track.outerIndex
        current = track.currentIndex
        length = Array.length arr
    in
    -- Array already sorted or end of array reached
    if track.sorted || outer >= length then
        { track
            | sorted = True
        }
    else
        if current <= 0 then
            -- Done inserting element at outerIndex, move to next element
            { track
                | outerIndex = outer + 1
                , currentIndex = outer + 1
                , didSwap = False
            }
        else
            case (Array.get current arr, Array.get (current - 1) arr) of
                (Just currentValue, Just previousValue) ->
                    if currentValue < previousValue then
                        let
                            -- Swap elements where smaller goes left
                            swappedArray =
                                Array.set (current - 1) currentValue (Array.set current previousValue arr)
                        in
                        -- Decrement currentIndex to move to front of array
                        { track
                            | array = swappedArray
                            , currentIndex = current - 1
                            , didSwap = True
                        }
                    else
                        -- No swap needed, so insertion for element is done
                        { track
                            | outerIndex = outer + 1
                            , currentIndex = outer + 1
                            , didSwap = False
                        }

                -- Default constructor
                _ ->
                    track
