/* 
   18. Вилучити зі списку елементи, що входять у нього по одному разу.
*/
count(_, [], 0).
count(X, [X|T], N) :-
    count(X, T, N1),
    N is N1 + 1.
count(X, [_|T], N) :-
    count(X, T, N).

remove_unique([], _, []).
remove_unique([H|T], Full, [H|Rest]) :-
    count(H, Full, N),
    N > 1,
    !,
    remove_unique(T, Full, Rest).
remove_unique([_|T], Full, Result) :-
    remove_unique(T, Full, Result).

solve(List, Result) :-
    remove_unique(List, List, Result).
