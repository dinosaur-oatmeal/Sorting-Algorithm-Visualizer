module BubbleSort exposing(..)

import Array exposing (Array)

{- BubbleSort: swaps adjacent elements if the element in the lower
   index is greater than the element in index + 1 -}

bubbleSortStep : Array Int -> Int -> (Array Int, Bool)
bubbleSortStep array index =
    -- Use case to avoid issues with comparing Maybe Int
    case (Array.get index array, Array.get (index + 1) array) of
        -- Valid Ints to be compared
        (Just currentValue, Just nextValue) ->
            if currentValue > nextValue then
                -- Swap the elements
                let
                    swappedArray =
                        Array.set index nextValue (Array.set (index + 1) currentValue array)
                in
                (swappedArray, True)
            else
                -- No swap needed
                (array, False)

        _ ->
            -- Default case: Do nothing if out of bounds
            (array, False)
