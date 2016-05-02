-module(road).
-compile(export_all).

main([FileName]) ->
    {ok, Bin} = file:read_file(FileName),
    Map = parse_map(Bin),
    io:format("~p~n", [optimal_path(Map)]),
    halt(0).

%% Transform a string into a readable map of triples
parse_map(Bin) when is_binary(Bin) ->
    parse_map(binary_to_list(Bin));
parse_map(Str) when is_list(Str) ->
    Values = [list_to_integer(X) || X <- string:tokens(Str, "\r\n\t ")],
    group_vals(Values, []).

group_vals([], Acc) ->
    lists:reverse(Acc);
group_vals([A, B, C|Rest], Acc) ->
    group_vals(Rest, [{A, B, C}|Acc]).

%% Actual problem solving
%% Change triples of the form {A, B, X} where A, B, X are distances and
%% a, b, x are possible paths to the form {DistanceSum, PathList}.
shortest_step({A, B, X}, {{DistA, PathA}, {DistB, PathB}}) ->
    OptA1 = {DistA + A, [{a, A}|PathA]},
    OptA2 = {DistB + B + X, [{x, X}, {b, B}|PathB]},
    OptB1 = {DistB + B, [{b, B}|PathB]},
    OptB2 = {DistA + A + X, [{x, X}, {a, A}|PathA]},
    {min(OptA1, OptA2), min(OptB1, OptB2)}.

%% Pick the best of all paths.
optimal_path(Map) ->
    {A, B} = lists:foldl(fun shortest_step/2, {{0, []}, {0, []}}, Map),
    {_Dist, Path} = if hd(element(2, A)) =/= {x, 0} -> A;
                       hd(element(2, B)) =/= {x, 0} -> B
                    end,
    lists:reverse(Path).
