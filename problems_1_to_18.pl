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

/*
P10 (*) Run-length encoding of a list.
    Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.

    Example:
    ?- encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[4,a],[1,b],[2,c],[2,a],[1,d][4,e]]
*/

encode(L1,L2):-pack(L1,P1), myEncode(P1,L2).
head([H|_],H).
myEncode([],[]).
myEncode([H|T],[[N,E]|X]):- length(H,N), head(H,E), myEncode(T,X).

/*
P11 (*) Modified run-length encoding.
    Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as [N,E] terms.

    Example:
    ?- encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[4,a],b,[2,c],[2,a],d,[4,e]]
*/

encode(L1,L2):-pack(L1,P1), myEncode(P1,L2).
head([H|_],H).
myEncode([],[]).
myEncode([H|T], [E|X]):- length(H,1), head(H,E), myEncode(T,X),!.
myEncode([H|T],[[N,E]|X]):- length(H,N), head(H,E), myEncode(T,X).

/*
P12 (**) Decode a run-length encoded list.
    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
*/

multi(1,E,[E]):-!.
multi(N,E,[E|X]):- M is N-1, multi(M,E,X).

decode([],[]).
decode([H|T],[H|X]):- \+ is_list(H), decode(T,Td), flatten(Td,X).
decode([[N,E]|T], L):- multi(N,E,H), decode(T,Td), flatten([H|Td],L).

/*
P13 (**) Run-length encoding of a list (direct solution).
    Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton terms [1,X] by X.

    Example:
    ?- encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
    X = [[4,a],b,[2,c],[2,a],d,[4,e]] */

count(E,[],[],[0,E]):-!.
count(E,[H|T],[H|T],[0,E]):-E \= H,!.
count(E,[E|T],L2,E):-count(E,T,L2,[0,E]),!.
count(E,[E|T],L2,[N,E]):- count(E,T,L2,[M,E]), N is M+1.

encode([],[]).
encode([H|T],[X|Y]):-count(H,[H|T],Z,X), encode(Z,Y).

/*
P14 (*) Duplicate the elements of a list.
    Example:
    ?- dupli([a,b,c,c,d],X).
    X = [a,a,b,b,c,c,c,c,d,d]
*/
dupli([],[]).
dupli([H|T], [H,H|X]):-dupli(T,X).

/*
P15 (**) Duplicate the elements of a list a given number of times.
    Example:
    ?- dupli([a,b,c],3,X).
    X = [a,a,a,b,b,b,c,c,c]

    What are the results of the goal:
    ?- dupli(X,3,Y).
*/
dupli([H|T],N,X):- iter(H,T,N,N,X).

iter(H,[],1,_,[H]):-!.
iter(H,[A|B],1,M,[H|Acc]):-iter(A,B,M,M,Acc),!.
iter(H,T,N,M,[H|Acc]):- Nn is N-1, iter(H,T,Nn,M,Acc).

/*
P16 (**) Drop every N'th element from a list.
    Example:
    ?- drop([a,b,c,d,e,f,g,h,i,k],3,X).
    X = [a,b,d,e,g,h,k]
*/

drop([H|T],N,X):- iter(H,T,N,N,X).

iter(_,[],1,_,[]):-!.
iter(H,[],_,_,[H]):-!.
iter(_,[A|B],1,M,Acc):- iter(A,B,M,M,Acc),!.
iter(H,[A|B],N,M,[H|Acc]):- Nn is N-1, iter(A,B,Nn,M,Acc).

/*
P17 (*) Split a list into two parts; the length of the first part is given.
    Do not use any predefined predicates.

    Example:
    ?- split([a,b,c,d,e,f,g,h,i,k],3,L1,L2).
    L1 = [a,b,c]
    L2 = [d,e,f,g,h,i,k]
*/

split(L,0,[],L):-!.
split([H|T],N,[H|Acc],Y):- M is N-1,split(T,M,Acc,Y).

/*
P18 (**) Extract a slice from a list.
    Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). Start counting the elements with 1.

    Example:
    ?- slice([a,b,c,d,e,f,g,h,i,k],3,7,L).
    X = [c,d,e,f,g]
*/

slice(L,I,J,S):- In is I-1, split(L,In,_,X), 
                 K is J-I, Kn is K+1, split(X,Kn,S,_).