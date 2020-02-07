-module(geometry).
-export([area/1]).

area({rectangle, Width, Height}) -> Width * Height;
area({square, S}) -> S * S;
area({circle, R}) -> 3.14159 * R * R.
