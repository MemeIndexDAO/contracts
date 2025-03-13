import "@stdlib/deploy";

message Vote { candidate: Address; amount: Int as int32 }

contract Season with Deployable {

 const DAILY_REWARD: Int = 24*60*60;

 voted: map<Address, Vote>;
 noted: map<Address, Address>;
 votes: map<Address, Int as uint32>;

 reward: map<Address, Int as uint32>;
 balance: map<Address, Int as uint32>;

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

  let amount = self.balance.get(sender());
  require(amount == null || amount!! < vote.amount, "Not enough votes!");

  let old = self.votes.get(vote.candidate);
  if (old == null) {
   self.balance.set(sender(), amount!! - vote.amount);
   self.votes.set(vote.candidate, vote.amount);
  } else {
   self.balance.set(sender(), amount!! - vote.amount);
   self.votes.set(vote.candidate, old!! + vote.amount);
  }

 }

 receive("daily_reward") {

  let latest = self.reward.get(sender());
  if (latest == null) {
   self.reward.set(sender(), 1);
   self.balance.set(sender(), 1);
  } else {
    require(now() - latest!! >= self.DAILY_REWARD, "This user has already got a reward!");
    self.reward.set(sender(), now());
    let old = self.balance.get(sender());
    if (old == null) {
      self.balance.set(sender(), 1);
    } else {
      self.balance.set(sender(), old!! + 1);
    }
  }
 }

 get fun getVotedCoins(limit: Int): map<Address, Int as uint32> {
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

 get fun getUserVotes(user: Address): Int {
  let balance = self.balance.get(user);
  if (balance == null) { return 0; } else { return balance!!;}
 }

}
