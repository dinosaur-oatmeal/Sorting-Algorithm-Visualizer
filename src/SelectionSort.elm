module SelectionSort exposing (selectionSortStep)

import Array exposing (Array)

{- SelectionSort: swaps current element with the smallest element in the array
   until min index and current index cross (end of array) -}

selectionSortStep : Array Int -> Int -> (Array Int, Bool)
selectionSortStep array index =
    let
        -- Find the index of the smallest element from `index` onward
        findMinIndex : Int -> Int -> Int -> Int
        findMinIndex currentMinIndex currentIndex arrayLength =
            -- Minimum index has been found
            if currentIndex >= arrayLength then
                currentMinIndex
            else
                -- Use case to avoid issues with comparing Maybe Int
                case (Array.get currentIndex array, Array.get currentMinIndex array) of
                    (Just currentValue, Just minValue) ->
                        -- update currentMinIndex to currentIndex and keep looking
                        if currentValue < minValue then
                            findMinIndex currentIndex (currentIndex + 1) arrayLength
                        -- keep looking for next min value
                        else
                            findMinIndex currentMinIndex (currentIndex + 1) arrayLength
                    -- Default case
                    _ ->
                        currentMinIndex

        -- Call findMinIndex for the unsorted portion of the array
        minIndex =
            findMinIndex index (index + 1) (Array.length array)

        swappedArray =
            case (Array.get index array, Array.get minIndex array) of
                (Just currentValue, Just minValue) ->
                    -- sets index to minValue and minIndex to currentValue
                    Array.set index minValue (Array.set minIndex currentValue array)

                -- Default Case
                _ ->
                    array

        -- See if a swap occured
        didSwap =
            index /= minIndex

    -- Package new array and didSwap for Main.elm to handle
    in
    (swappedArray, didSwap)
