/*
   Задача 18: виявити, чи допускає скінчений автомат 
   хоча б одне слово, довжина якого парна.
*/



accepts(Q, []) :-
    final(Q).
accepts(Q, [A|Rest]) :-
    trans(Q, A, Q1),
    accepts(Q1, Rest).


even(0).
even(N) :- N > 0, N1 is N - 2, even(N1).


alphabet([a,b]).

find_even_word(MaxLen, Word) :-
    between(0, MaxLen, Len),
    even(Len),
    length(Word, Len),
    alphabet(Alph),
    maplist(member(Alph), Word),
    start(Q),
    accepts(Q, Word).


task18 :-
    numStates(N),
    MaxLen is 2 * N,
    ( find_even_word(MaxLen, Word) ->
        write('Yes! Example word: '), write(Word), nl
    ;
        write('No word with even length.'), nl
    ).





test1 :-
    write('=== Test 1: accepts "aa" ==='), nl,
    assert(start(q0)),
    assert(final(q2)),
    assert(trans(q0, a, q1)),
    assert(trans(q1, a, q2)),
    assert(numStates(3)),
    task18,
    retractall(start(_)),
    retractall(final(_)),
    retractall(trans(_, _, _)),
    retractall(numStates(_)).


test2 :-
    write('=== Test 2: only odd length words ==='), nl,
    assert(start(q0)),
    assert(final(q1)),
    assert(trans(q0, a, q1)),
    assert(trans(q1, a, q0)),
    assert(numStates(2)),
    task18,
    retractall(start(_)),
    retractall(final(_)),
    retractall(trans(_, _, _)),
    retractall(numStates(_)).


test3 :-
    write('=== Test 3: accepts empty word (length 0) ==='), nl,
    assert(start(q0)),
    assert(final(q0)),
    assert(numStates(1)),
    task18,
    retractall(start(_)),
    retractall(final(_)),
    retractall(trans(_, _, _)),
    retractall(numStates(_)).


test4 :-
    write('=== Test 4: accepts (bb)* ==='), nl,
    assert(start(q0)),
    assert(final(q0)),
    assert(trans(q0, b, q1)),
    assert(trans(q1, b, q0)),
    assert(numStates(2)),
    task18,
    retractall(start(_)),
    retractall(final(_)),
    retractall(trans(_, _, _)),
    retractall(numStates(_)).

:- initialization(main).

main :-
    test1, nl,
    test2, nl,
    test3, nl,
    test4.
