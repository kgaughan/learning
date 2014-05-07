(*
 * Reasonably efficient integer factorisation.
 *
 * The algorithm is a variation on trial division. First we try all the primes
 * less than sqrt(n) + 1 (the biggest potential number that might be a prime
 * factor without the number itself being prime), dividing our primes into our
 * original number and recording any which divide cleanly. If, by the end,
 * we've generated no prime factors, then our original number was a prime, so
 * we append that to our list.
 *)
