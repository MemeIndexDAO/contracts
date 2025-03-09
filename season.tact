
message Vote { candidate: Address; amount: Int as int32 }

contract Season {

 voted: map<Address, Vote>;
 noted: map<Address, Address>;
 votes: map<Address, Int as int32>;

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
   self.votes.replace(vote.candidate, old!! + vote.amount);
  }

 }

 get fun getVotedCoins(limit: Int): map<Address, Int as int32> {
  return self.votes;
 }
 
 // TODO: we don't have information about coins here yet
 get fun getCoinDetails(limit: Int): map<Address, Int> {
  return emptyMap();
 }

 get fun getVoteCount(coin: Address): Int {
  let found = self.votes.get(coin);
  require(found != null, "This coin is not found!");
  return self.votes.get(coin)!!;
 }

}