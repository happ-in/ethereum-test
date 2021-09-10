const Lottery = artifacts.require("Lottery");

// 최대 10명 까지 가능 (accounts정보들이 순서대로 들어감)
contract("Lottery", function ([deployer, user1, user2]) {
  let lottery;
  beforeEach(async () => {
    console.log("Before each");
    lottery = await Lottery.new();
  });

  it("Basic test", async () => {
    console.log("Basic test");
    let owner = await lottery.owner();
    let value = await lottery.getSomeValue();

    console.log(`owner : ${owner}`);
    console.log(`value : ${value}`);
    assert.equal(value, 5);
  });
});
