/*
santasStable.pl

Philippe Nadon
AUCSC370
Dec 9, 2018

A program which solves Santa's Stable riddle, 
using only the facts stated in the riddle's rules

Enter "santasStable." to run the program

Program runtime on Intel i7 8850H, 6-core @ 4.1 GHz:
~30 seconds
*/
santasStable :-
  solve( S),
  showRes( S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elves(['Alabaster Snowball', 'Bushy Evergreen', 'Pepper Minstix',
       'Shinny Upatree', 'Sugarplum Mary', 'Wunorse Openslae']).
areas([1, 2, 3, 4, 5, 6]).
toys([15, 14, 12, 10, 9, 7]).
reindeer(['Dasher', 'Prancer', 'Vixen', 'Comet', 'Blitzen', 'Rudolf']).

solution([
[1, _, _, _],
[2, _, _, _],
[3, _, _, _],
[4, _, _, _],
[5, _, _, _],
[6, _, _, _]
]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Rudolf hangs out two or more areas to the east of Wunorse Openslae’s reindeer
*/
rule1( S) :-
  member([ AreaR, 'Rudolf', _, _], S),
  member([ OArea, _, 'Wunorse Openslae', _], S),
  OArea < AreaR - 1.


/*
 The reindeer of the elf that made nine toys lives somewhere to the west of
Alabaster Snowball’s reindeer
*/
rule2( S) :-
  member([ Area, _, _, 9], S),
  member([ OArea, _, 'Alabaster Snowball', _], S),
  Area < OArea.


/*
 Three reindeer in consecutive areas, from west to east, are Dasher, Alabaster
Snowball’s reindeer, and the reindeer of the elf that made 12 toys.
*/
rule3( S) :-
  member([ Area1, 'Dasher', _, _], S),
  member([ Area2, _, 'Alabaster Snowball', _], S),
  member([ Area3, _, _, 12], S),
  Area2 is Area1 + 1,
  Area3 is Area1 + 2.


/*
The elf who rode Rudolf has made three toys more than the one who rode the
reindeer in area 4, while Pepper Minstix made three toys more than Sugarplum
Mary. All four elves mentioned here are unique.
 */
rule4( S) :-
  member([ _, 'Rudolf', Elf, Toys], S),
  member([ 4, _, Elf4, Toys4], S),
  member([ _, _, 'Pepper Minstix', ToysP], S),
  member([ _, _, 'Sugarplum Mary', ToysS], S),
  Elf \== 'Pepper Minstix',
  Elf \== 'Sugarplum Mary',
  Elf4 \== 'Pepper Minstix',
  Elf4 \== 'Sugarplum Mary',
  Toys is Toys4 + 3,
  ToysP is ToysS + 3.


/*
Comet’s rider made three toys more than Shinny Upatree, who in turn made two
toys more than the elf who rode Vixen.
 */
rule5( S) :-
  member([ _, 'Comet', _, Toys], S),
  member([ _, _, 'Shinny Upatree', ToysS], S),
  member([ _, 'Vixen', _, ToysV], S),
  Toys is ToysS + 3,
  Toys is ToysV + 5.

/*
The elf who rode Vixen is Shinny Upatree,
Sugarplum Mary or Wunorse Onenslae.
 */
rule6( S) :-
  member([_, 'Vixen', 'Shinny Upatree', _], S).

rule6( S) :-
  member([_, 'Vixen', 'Sugarplum Mary', _], S).

rule6( S) :-
  member([_, 'Vixen', 'Wunorse Openslae', _], S).


% Blitzen lives somewhere to the west of Bushy Evergreen’s reindeer
rule7( S) :-
  member([ Area, 'Blitzen', _, _], S),
  member([ OArea, _, 'Bushy Evergreen', _], S),
  Area < OArea.


% Alabaster Snowball made exactly one toy more than Wunorse Openslae.
rule8( S) :-
  member([ _, _, 'Alabaster Snowball', Toys], S),
  member([ _, _, 'Wunorse Openslae', OToys], S),
  Toys is OToys + 1.


% Pepper Minstix didn’t ride the reindeer from area 6.
rule9( S) :-
  member([ 6, Reindeer, _, _], S),
  member([ _, OReindeer, 'Pepper Minstix', _], S),
  OReindeer \== Reindeer.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSTRAINT RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Possible toys are within toys list.
constrainToys([]).
constrainToys([[_, _, _, Toys] | Rest]) :-
  toys(ToysList),
  member(Toys, ToysList),
  constrainToys(Rest).

% Possible areas are within areas list.
constrainAreas([]).
constrainAreas([[Area, _, _, _] | Rest]) :-
  areas(AreaList),
  member(Area, AreaList),
  constrainAreas(Rest).

% Possible reindeer are within reindeer list.
constrainReindeer([]).
constrainReindeer([[_, Reindeer, _, _] | Rest]) :-
  reindeer(ReindeerList),
  member(Reindeer, ReindeerList),
  constrainReindeer(Rest).

% Each area's reindeer is exclusive.
exclusiveReindeer([
[ _, R1, _, _],
[ _, R2, _, _],
[ _, R3, _, _],
[ _, R4, _, _],
[ _, R5, _, _],
[ _, R6, _, _]]) :-
  R1 \== R2, R1 \== R3, R1 \== R4, R1 \== R5, R1 \== R6,
  R2 \== R3, R2 \== R4, R2 \== R5, R2 \== R6,
  R3 \== R4, R3 \== R5, R3 \== R6,
  R4 \== R5, R4 \== R6,
  R5 \== R6.

% Each area's elf is exclusive.
exclusiveElves([
[ _, _, E1, _],
[ _, _, E2, _],
[ _, _, E3, _],
[ _, _, E4, _],
[ _, _, E5, _],
[ _, _, E6, _]]) :-
  E1 \== E2, E1 \== E3, E1 \== E4, E1 \== E5, E1 \== E6,
  E2 \== E3, E2 \== E4, E2 \== E5, E2 \== E6,
  E3 \== E4, E3 \== E5, E3 \== E6,
  E4 \== E5, E4 \== E6,
  E5 \== E6.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve( S) :-
  solution( S),
  constrainToys( S),
  constrainAreas( S),
  member([_,'Prancer', _, _], S),
  rule5( S),
  rule6( S),
  rule9( S),
  rule1( S),
  rule3( S),
  rule4( S),
  rule2( S),
  rule7( S),
  rule8( S),
  exclusiveElves( S),
  exclusiveReindeer( S).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRINT FORMATTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

showRes( S) :-
  nl,
  write('Area    Reindeer     Elf                 Toys'), nl,
  write('----    --------     ---                 ----'), nl,
  showResREC( S).

showResREC([]).
showResREC( [[Area, Reindeer, Elf, Toys] | Rest]) :-
  writef('%7l %12l %19l %4r', [Area, Reindeer, Elf, Toys]), nl,
  showResREC(Rest).
