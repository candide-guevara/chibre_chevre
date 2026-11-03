/// Seats are numbered 0 to 3 in playing (counter-clockwise) order.
/// Seats 0 and 2 form team 0 (the humans), seats 1 and 3 form team 1.
const seatCount = 4;

int nextSeat(int seat) => (seat + 1) % seatCount;

int partnerOf(int seat) => (seat + 2) % seatCount;

int teamOf(int seat) => seat % 2;

int opponentTeam(int team) => 1 - team;
