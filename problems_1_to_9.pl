/*
P01 (*) Find the last element of a list.
    Example:
    ?- my_last([a,b,c,d],X).
    X = d
*/

my_last(A,[A]).
my_last(X, [_|T],):- my_last(X,T).

/*
P02 (*) Find the last but one element of a list.
    (zweitletztes Element, l'avant-dernier élément)
*/

my2(H,[H,_]).
my2(X,[_|T]):-my2(X,T).

/*
P03 (*) Find the K'th element of a list.
    The first element in the list is number 1.
    Example:
    ?- element_at(X,[a,b,c,d,e],3).
    X = c
*/

kElement(H,[H|_],1).
kElement(X,[_|T],K):- kElement(X,T,J), K is J + 1.


/* 
P04 (*) Find the number of elements of a list.
*/

size(0,[]).
size(X,[_|T]):- size(Y,T), X is Y + 1. 


/*
P05 (*) Reverse a list.
*/

my_reverse(L1,L2):- iter(L1,[],L2).
iter([],L2,L2).
iter([H|T],Acc,L2):-iter(T,[H|Acc],L2),!.

/*
P06 (*) Find out whether a list is a palindrome.
    A palindrome can be read forward or backward; e.g. [x,a,m,a,x].
*/

palindrome(L):-my_reverse(L,R), L == R.

/*
P07 (**) Flatten a nested list structure.
    Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).

    Example:
    ?- my_flatten([a, [b, [c, d], e]], X).
    X = [a, b, c, d, e]

    Hint: Use the predefined predicates is_list/1 and append/3
*/

myflatten([],[]).
myflatten(H,[H]):- \+ is_list(H).
myflatten([H|T],F):- myflatten(H,Hf), myflatten(T,Tf), append(Hf,Tf,F).


/*
P08 (**) Eliminate consecutive duplicates of list elements.
    If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.

    Example:
    ?- compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [a,b,c,a,d,e]
*/

distinct([X],[X]).
distinct([H1,H2|T], [H1|X]):- H1 \= H2, distinct([H2|T],X).
distinct([H,H|T], X):- distinct([H|T],X).

/*
P09 (**) Pack consecutive duplicates of list elements into sublists.
    If a list contains repeated elements they should be placed in separate sublists.

    Example:
    ?- pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]
*/

pack(L1,L2):- reverse(L1,R1), iter(R1,[],L2).

iter([],Z,Z).
iter([H|T],[],Z):- iter(T,[[H]],Z),!.
iter([H|T],[[H|B]|C],Z):- iter(T,[[H,H|B]|C],Z).
iter([H|T],[[A|B]|C],Z):- H \= A, iter(T,[[H],[A|B]|C],Z).
