module ShellSort exposing (shellSortStep)

import Array exposing (Array)
import Structs exposing (SortingTrack)


{- Uses a gap to move elements to the right side of the gap in the array
   The left side of the gap will be < gap and right will be > gap
   Once the gap is 1, a final pass is done to move every element in the right position
   (Optimized version of Insertion Sort because elements far apart can be swapped)
-}

shellSortStep : SortingTrack -> SortingTrack
shellSortStep track =
    let
        arr = track.array
        length = Array.length arr
        outer = track.outerIndex
        current = track.currentStep
        gap = track.minIndex
    in
    -- Array already sorted or gap too small
    if track.sorted || gap <= 0 then
        { track
            | sorted = True
        }

    else
        -- Pass finished (end of array hit)
        if outer >= length then
            let
                -- Reduce to 0 if 1 to be sorted
                newGap =
                    if gap == 1 then
                        0
                    else
                        -- Half gap
                        gap // 2
            in
            -- Update track for next pass with new gap
            { track
                | outerIndex = newGap
                , currentStep = newGap
                , minIndex = newGap
            }

        else
            -- All elements compared (pass complete), so go to next element
            if current < gap then
                { track
                    | outerIndex = outer + 1
                    , currentStep = outer + 1
                }
            else
                -- Compare current element to (current - gap) element
                case ( Array.get current arr, Array.get (current - gap) arr ) of
                    ( Just currentValue, Just gapValue ) ->
                        if currentValue < gapValue then
                            let
                                -- Swap values if currentValue < gapValue
                                updatedArray =
                                    arr
                                        |> Array.set (current - gap) currentValue
                                        |> Array.set current gapValue
                            in
                            -- Update track with new array and currentStep to previous position
                            { track
                                | array = updatedArray
                                , currentIndex = current - gap
                                , currentStep = current - gap
                            }

                        else
                            -- No Swap, so move to next element
                            { track
                                | outerIndex = outer + 1
                                , currentStep = outer + 1
                            }

                    -- Default constructor
                    _ ->
                        track
