module InsertionSort exposing (insertionSortStep)

import Array exposing (Array)

{- InsertionSort: finds a value that less than element at index and
   moves it into the correct index of the partially-sorted array -}

insertionSortStep : Array Int -> Int -> (Array Int, Bool)
insertionSortStep array index =
    let
        -- Move element backward in array
        moveBackward : Array Int -> Int -> (Array Int, Bool)
        moveBackward currentArray currentIndex = 
            -- Beginning of array and stop
            if currentIndex <= 0 then
                (currentArray, False)

            else    
                -- Use case to avoid issues with comparing Maybe Int
                case (Array.get currentIndex currentArray, Array.get (currentIndex - 1) currentArray) of
                    -- Valid Ints to be compared
                    (Just currentValue, Just previousValue) ->
                        -- Current value < value before it
                        if currentValue < previousValue then
                            -- Swap the elements
                            let
                                swappedArray =
                                    Array.set currentIndex previousValue
                                        (Array.set (currentIndex - 1) currentValue currentArray)

                            in
                            -- Recurse to keep moving value back
                            moveBackward swappedArray (currentIndex - 1)

                        else
                            -- Current value in right position
                            (currentArray, False)

                    -- Default case
                    _ ->
                        (currentArray, False)
        
        -- start moving current element in array to right position
        (newArray, didSwap) =
            moveBackward array index

    -- Package new array and didSwap for Main.elm to handle
    in
    (newArray, didSwap)