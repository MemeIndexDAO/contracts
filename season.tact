// Season prototype

// Additional questions:
// 1. If a user register some token, can we count it as +1 vote for it already?
// 2. Can a user register more than one tokens in the same season?

// Additional improvements:
// Add logging everywhere - should help with debugging

// struct Token { ticket: String; }

message Vote { candidate: Address }

// message Note { candidate: Address }

contract Season {

 voted: map<Address, Address>;
 noted: map<Address, Address>;
 votes: map<Address, Int>;

 init() {
  self.voted = emptyMap();
  self.noted = emptyMap();
  self.votes = emptyMap();
 }

 receive(vote: Vote) {

  let voted = self.voted.get(sender());
  require(voted != null, "This user has already voted!");

  let token = self.noted.get(vote.candidate);
  require(token == null, "This token is not registered!");

  let old = self.votes.get(vote.candidate);
  if (old == null) {
   self.votes.replace(vote.candidate, 0);
  } else {
   self.votes.replace(vote.candidate, old!! + 1);
  }

 }

 // note(note: Note) {}

}
