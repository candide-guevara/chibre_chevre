# Project specs

The goal of this project is to create a phone app to play the [chibre][0] card game.

## Requirements

* 2 human players, each with their own phone, will be playing against a team controlled by the computer.
* the app shall not collect any personal data, nor have any form of account.
* most of the computation should happen on the phones, ideally I prefer not to have any backend.
  * backend infra will be hosted on AWS. the design should minimize data transfer volume and QPS to minimize costs.
* the whole system (app and backend) must be runnable locally on my machine for demo purposes and quick feedback.
  * later on we will see how to create the needed google app dev and aws accounts.
* the computer players should be expert level to challenge the humans.

## Out of scope

* Only 2 player mode is supported.
* The app will never be monetized, this is just to have fun with my friends.
* Users of the app can be trusted not to cheat.

## Tech stack

* The application should use the flutter framework.
* Only use dependencies from trusted sources (ex dart.dev), prefer re-implementation to depending on a module from a random dude on the internet.
* If a backend is needed use aws lambda running golang code and dynamoDb for persistent state.
  * client/backend traffic will be done using binary over HTTP to encode protocoll buffer messages.
  * lambda must use few dependencies to optimize cold starts, bloated frameworks like Django are forbidden.

## Start screen

It consists of 3 buttons

* Join game
* Host game
* Player details

Until the player details are input, the join and host buttons must be greyed out.

## Player details screen

Just a text input field for their nickname.
The players details will be stored locally on the phone never on the backend.
It is however allowed to communicate those details to the other player when joining a game.

## Join game screen

Displays a list of open games.
Tapping on a game will open the play game screen

## Host game screen

Allows to configure different options:

* game name (prefiled with "<nickname>'s game"
* number of points (default 1000)

A button "start game" will open the waiting for player screen.

## Waiting for player screen

Mentions that it is waiting for players, has a cancel button to go back to start screen.

## Play game screen

The players cards are shown at the bottom.
In case the player wants to call a meld, they must select the relevant cards and tap the "call meld".
The app must verify there is no error when calling the meld.
Then the game starts.

## End game screen

* Shows both teams scores.
* A button to go to the insights screen
* A button to rematch
* A buttong to go to the start screen

## Insights screen

During the course of the game all the moves and starting cards are recorded.
The computer expert plows through the data and surfaces the 3 biggest blunders it saw for each human player.
For example failing to call a meld.

At the end of the screen:

* A button to rematch
* A button to rematch with the exact same card distributions as before
* A buttong to go to the start screen

## Graphic design

* Overall sober, no tacky decorations on buttons.
* Use a color palette derived from billiard green.
* Use Swiss-French cards (diamonds, hearts, ...)
* For the cards design we will be original and design our own:
  * Use rubber hose cartoon style
  * Instead of humans use monkeys, cows and zebras (do not mix them but generate different card sets per animal and select one set at random at the start of each game).

[0]: https://www.swisslos.ch/fr/jass/informations/les-regles-du-jass/bases-du-jass.html
