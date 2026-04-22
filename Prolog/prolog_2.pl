/*
   56. Підрахувати кількість нулів, решту розподілити
   по списках з додатніх та від'ємних чисел.
*/

split([], 0, [], []).
split([0|T], Count, Pos, Neg) :-
    split(T, Count1, Pos, Neg),
    Count is Count1 + 1.
split([H|T], Count, [H|Pos], Neg) :-
    H > 0,
    split(T, Count, Pos, Neg).
split([H|T], Count, Pos, [H|Neg]) :-
    H < 0,
    split(T, Count, Pos, Neg).
