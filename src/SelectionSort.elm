module SelectionSort exposing (selectionSortStep)

import Array exposing (Array)

-- Access to struct needed for program
import Structs exposing (SortingTrack)

{-  Move through the array with outerIndex
    For each outerIndex, find the smallest element in the rest of array
    When currentIndex reaches the end of the array, swap outerIndex with currentIndex
    Increment outerIndex and repeat until the end of the array is hit
-}

selectionSortStep : SortingTrack -> SortingTrack
selectionSortStep track =
    let
        arr = track.array
        outer = track.outerIndex
        current = track.currentIndex
        minimum = track.minIndex
        length = Array.length arr
    in
    -- Array already sorted or end of array reached
    if track.sorted || outer >= length then
        { track
            | sorted = True
        }
    else
        if current < length then
            -- Compare element at current with element at minimum
            case (Array.get current arr, Array.get minimum arr) of
                (Just currentValue, Just minimumValue) ->
                    if currentValue < minimumValue then
                        -- Found a new minimum, so set minIndex to current and increase currentIndex
                        { track
                            | currentIndex = current + 1, minIndex = current
                        }
                    else
                        -- Current element isn't smaller than min, so increase currentIndex
                        { track
                        | currentIndex = current + 1
                        }

                -- Default constructor
                _ ->
                    track

        else
            -- currentIndex reached end of array so swap minIndex with outerIndex
            case (Array.get outer arr, Array.get minimum arr) of
                (Just outerValue, Just minimumValue) ->
                    let
                        updatedArray =
                            -- Swap outerValue with minimumValue if smaller
                            if minimum /= outer then
                                Array.set outer minimumValue (Array.set minimum outerValue arr)
                            -- Return array if not smaller
                            else
                                arr
                    in
                    -- Update track to reflect changes
                    { track
                        | array = updatedArray
                        , outerIndex = outer + 1
                        , currentIndex = outer + 2
                        , minIndex = outer + 1
                    }

                -- Default constructor
                _ ->
                    track
