-module(what_the_if).
-export([heh_fine/0, oh_god/1, help_me/1, help_me1/1]).

heh_fine() ->
    if 1 =:= 1 ->
        works
    end,
    if 1 =:= 2; 1 =:= 1 ->
        works
    end,
    if 1 =:= 2, 1 =:= 1 ->
        fails
    end.

oh_god(N) ->
    if N =:= 2 -> might_succeed;
       true -> always_does % this is Erlang's if's 'else'
    end.

%% Note: this one would be better as a pattern match in function heads!
help_me(Animal) ->
    Talk = if Animal == cat -> "meow";
              Animal == beef -> "mooo";
              Animal == dog -> "bark";
              Animal == tree -> "bark";
              true -> "fdgadfgna"
           end,
    {Animal, "says " ++ Talk ++ "!"}.

talk(cat) -> "meow";
talk(beef) -> "mooo";
talk(dog) -> "bark";
talk(tree) -> "bark";
talk(_) -> "fdgadfgna".

help_me1(Animal) ->
    {Animal, "says " ++ talk(Animal) ++ "!"}.
