foldl' _    initial []     = initial
foldl' step initial (x:xs) =
  let new = step initial x
  in  new `seq` foldl' step new xs

strictPair (a, b) = a `seq` b `seq` (a, b)

strictList (x:xs) = x `seq` x : strictList xs
strictList []     = []
