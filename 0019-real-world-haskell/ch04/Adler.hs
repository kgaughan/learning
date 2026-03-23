import Data.Char (ord)
import Data.Bits (shiftL, (.&.), (.|.))

base = 65521

adler32 xs = let (a, b) = foldl step (1, 0) xs
              in (b `shiftL` 16) .|. a
  where step (a, b) x = let a' = a + (ord x .&. 0xFF)
                        in (a' `mod` base, (a' + b) `mod` base)
