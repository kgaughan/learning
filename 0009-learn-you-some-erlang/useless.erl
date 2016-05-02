-module(useless).
-export([add/2, hello/0, greet_and_add_two/1, same/2, valid_time/1]).

add(A, B) ->
    A + B.

hello() ->
    io:format("Hello, world!~n").

greet_and_add_two(X) ->
    hello(),
    add(X, 2).

same(X, X) ->
    true;
same(_, _) ->
    false.

valid_time({Date = {Y, M, D}, Time = {H, Min, S}}) ->
    io:format("The Date tuple (~p) says today is: ~p/~p/~p,~n", [Date, Y, M, D]),
    io:format("The Time tuple (~p) indicates: ~p:~p:~p.~n", [Time, H, Min, S]);
valid_time(_) ->
    io:format("Stop feeding me wrong data!~n").
