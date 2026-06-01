/*
   (8+6 балів). 1.Виявити досяжні та недосяжні нетермінали. 
   Забезпечити еквівалентне перетворення граматики з метою елімінації недосяжних нетерміналів.
*/


nts_in_rhs([], []).
nts_in_rhs([H|T], [H|NTs]) :-
    nt(H), !,
    nts_in_rhs(T, NTs).
nts_in_rhs([_|T], NTs) :-
    nts_in_rhs(T, NTs).


add_new([], Acc, Acc).
add_new([H|T], Acc, Result) :-
    (   member(H, Acc)
    ->  add_new(T, Acc, Result)
    ;   add_new(T, [H|Acc], Result)
    ).


expand_step(Current, Next) :-
    findall(B,
        (   member(A, Current),
            rule(A, RHS),
            nts_in_rhs(RHS, NTs),
            member(B, NTs)
        ),
        New),
    add_new(New, Current, Next).


fixpoint(Current, Result) :-
    expand_step(Current, Next),
    (   Next = Current
    ->  Result = Current
    ;   fixpoint(Next, Result)
    ).


reachable(Reachable) :-
    start(S),
    fixpoint([S], Reachable).


transformed(Rules) :-
    reachable(Reachable),
    findall(A-RHS,
        (   rule(A, RHS),
            member(A, Reachable)
        ),
        Rules).


print_rules([]).
print_rules([A-RHS|T]) :-
    write('  '), write(A), write(' -> '), write(RHS), nl,
    print_rules(T).

run_task :-
    findall(A, nt(A), AllNTs),
    reachable(Reachable),
    subtract(AllNTs, Reachable, Unreachable),
    transformed(Rules),
    write('All nonterminals:    '), write(AllNTs), nl,
    write('Reachable:           '), write(Reachable), nl,
    write('Unreachable:         '), write(Unreachable), nl,
    write('Transformed grammar:'), nl,
    print_rules(Rules).


test1 :-
    write('=== Test 1: B and C are unreachable ==='), nl,
    assert(start(s)),
    assert(nt(s)), assert(nt(a)), assert(nt(b)), assert(nt(c)),
    assert(rule(s, [x, a])),
    assert(rule(a, [y])),
    assert(rule(b, [z, c])),
    assert(rule(c, [w])),
    run_task,
    retractall(start(_)), retractall(nt(_)), retractall(rule(_,_)),
    nl.

test2 :-
    write('=== Test 2: all nonterminals are reachable ==='), nl,
    assert(start(s)),
    assert(nt(s)), assert(nt(a)), assert(nt(b)),
    assert(rule(s, [a, b])),
    assert(rule(a, [x])),
    assert(rule(b, [y])),
    run_task,
    retractall(start(_)), retractall(nt(_)), retractall(rule(_,_)),
    nl.

test3 :-
    write('=== Test 3: chain S->A->B->C, D unreachable ==='), nl,
    assert(start(s)),
    assert(nt(s)), assert(nt(a)), assert(nt(b)), assert(nt(c)), assert(nt(d)),
    assert(rule(s, [a])),
    assert(rule(a, [b])),
    assert(rule(b, [c])),
    assert(rule(c, [x])),
    assert(rule(d, [y])),
    run_task,
    retractall(start(_)), retractall(nt(_)), retractall(rule(_,_)),
    nl.

test4 :-
    write('=== Test 4: only S is reachable ==='), nl,
    assert(start(s)),
    assert(nt(s)), assert(nt(a)), assert(nt(b)),
    assert(rule(s, [x])),
    assert(rule(a, [y])),
    assert(rule(b, [z])),
    run_task,
    retractall(start(_)), retractall(nt(_)), retractall(rule(_,_)),
    nl.


:- initialization(main).
main :- test1, test2, test3, test4.
