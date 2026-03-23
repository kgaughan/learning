class BasicEq a where
  isEqual, isNotEqual :: a -> a -> Bool
  isEqual x y = not (isNotEqual x y)
  isNotEqual x y = not (isEqual x y)

data Color = Red
           | Green
           | Blue

instance Show Color where
  show Red   = "Red"
  show Green = "Green"
  show Blue  = "Blue"

instance Read Color where
  -- readsPrec is the main function for parsing input
  readsPrec _ value =
    -- We pass tryParse a list of pairs. Each pair has a string and the
    -- desired return value. tryParse will try to match the input to one of
    -- these strings.
    tryParse [("Red", Red), ("Green", Green), ("Blue", Blue)]
    where tryParse [] = []
          tryParse ((attempt, result):xs) =
            -- Compare the start of the string to be parsed to the text we're
            -- looking for.
            if (take (length attempt) value) == attempt
               -- If we have a match, return the result and the remaining input
               then [(result, drop (length attempt) value)]
               -- Otherwise try the next pair in the list of attempts
               else tryParse xs
