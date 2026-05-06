/*
   26. Розбити заданий список на N списків відповідно з числами, що мають вигляд Nk, Nk+1, Nk+2, … Nk+(N-1)
для деякого цілого k. (Критерій розбиття – значення остачі при діленні на N).
*/

filter_by_rem([], _, _, []).
filter_by_rem([H|T], N, Rem, [H|Rest]) :-
    H mod N =:= Rem,
    filter_by_rem(T, N, Rem, Rest).
filter_by_rem([_|T], N, Rem, Rest) :-
    filter_by_rem(T, N, Rem, Rest).

build_groups(_, N, N, []).
build_groups(List, N, Rem, [Group|Rest]) :-
    filter_by_rem(List, N, Rem, Group),
    NextRem is Rem + 1,
    build_groups(List, N, NextRem, Rest).

split_n(List, N, Groups) :-
    build_groups(List, N, 0, Groups).
