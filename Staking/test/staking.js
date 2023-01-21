const { expect } = require("chai");
const { ethers } = require("hardhat");
require("hardhat-gas-reporter");


describe("TestStakingToken", function () {

    let owner
    let acc1
    const SEC_IN_DAY = 86400;

    function timeConverter(UNIX_timestamp) {
        var a = new Date(UNIX_timestamp * 1000);
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var year = a.getFullYear();
        var month = months[a.getMonth()];
        var date = a.getDate();
        var hour = a.getHours();
        var min = a.getMinutes();
        var sec = a.getSeconds();
        var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec;
        return time;
    }
    //   console.log(timeConverter(0));

    async function getTimestamp(bn) {
        return (
            await ethers.provider.getBlock(bn)
        ).timestamp
    }

    beforeEach(async function () {
        [owner, acc1] = await ethers.getSigners()

        const token = await hre.ethers.getContractFactory("TestStakingToken");
        TSTtoken = await token.deploy();
        await TSTtoken.deployed();

        const stake = await hre.ethers.getContractFactory("Staking");
        Staking = await stake.deploy(TSTtoken.address);
        await Staking.deployed();
    })

    it("sets owner", async function () {

        const _owner = await TSTtoken.owner()
        // console.log(_owner)
        expect(_owner).to.eq(owner.address)

        const __owner = await Staking.owner()
        // console.log(__owner)
        expect(__owner).to.eq(owner.address)
    })

    it("should allow mint token", async function () {
        await TSTtoken.connect(owner).mint(owner.address, 100000);
        await TSTtoken.connect(owner).mint(Staking.address, 1000000);
        await TSTtoken.connect(owner).mint(acc1.address, 100000);
        await expect(TSTtoken.connect(acc1).mint(owner.address, 100000))
            .to.be.revertedWith("Ownable: caller is not the owner");
        // console.log(await TSTtoken.connect(owner).balanceOf(owner.address));
        await TSTtoken.connect(owner).approve(Staking.address, 50000)
        await TSTtoken.connect(acc1).approve(Staking.address, 50000)
        expect(await TSTtoken.connect(owner).allowance(owner.address, Staking.address))
            .to.eq(50000);
        // set rewards // 1 year - 30%  6 month - 24%   3 month - 20%  2 month - 18%  1 month - 12%
        await Staking.connect(owner).setRewards(24, 180);
        expect(await Staking.connect(owner).rewards(180))
            .to.eq(24);
        await Staking.connect(owner).setRewards(20, 90);
        expect(await Staking.connect(owner).rewards(90))
            .to.eq(20);
        await Staking.connect(owner).setRewards(12, 30);
        await Staking.connect(owner).setRewards(30, 365);
        await Staking.connect(owner).setRewards(18, 60);
        // set enable staking
        await Staking.connect(owner).setStakeToggle()
        expect(await Staking.connect(owner).stakingEnabled())
            .to.be.true
        // stake tokens through out various time
        await expect(await Staking.connect(acc1).stake(20000, 190))
            .to.emit(Staking, 'deposit')
            .withArgs(1, acc1.address)
        await Staking.connect(acc1).stake(10000, 60)
        await expect(await Staking.connect(owner).stake(2000, 90))
            .to.emit(Staking, 'deposit')
            .withArgs(1, owner.address)
        await Staking.connect(owner).stake(6000, 180)
        await Staking.connect(owner).stake(6000, 90)
        await Staking.connect(owner).stake(8000, 90)
        const tt = await Staking.connect(owner).stake(10000, 390) // 24%
        await tt.wait()
        const tp = await getTimestamp(tt.blockNumber)
        console.log(timeConverter(tp));

        // expect revert
        await expect(Staking.connect(acc1).stake(100000, 200))
            .to.be.revertedWith("Failed send funds");
        await expect(Staking.connect(acc1).stake(0, 200))
            .to.be.revertedWith("Wrong amount");

        console.log(
            "Token address=>", TSTtoken.address, "Staking address=>", Staking.address
        );
        // console.log(await Staking.connect(owner).TST());

        const stakeLength = await Staking.connect(owner).stakeNonce(owner.address);
        const arr = Array.from({ length: stakeLength }, (_, i) => i + 1)
        // console.log(arr);
        // console.log((await Staking.connect(owner).stakeBalances(owner.address, 3)).amount) // !!!!!!!!

        //fetch all deposits of customers
        const deposits = await Promise.all(
            arr.map(async el => {
                return (await Staking.connect(owner).stakeBalances(owner.address, el)).amount
            })
        )
        //fetch time 
        const endTime = await Promise.all(
            arr.map(async el => {
                return timeConverter((await Staking.connect(owner).stakeBalances(owner.address, el)).endAt)
            })
        )
        //fetch rewarValue
        const rewards = await Promise.all(
            arr.map(async el => {
                return (await Staking.connect(owner).stakeBalances(owner.address, el)).rewardValue
            })
        )
        // console.log(deposits, endTime, rewards);

        expect(await Staking.connect(owner).tokensStakedByAddress(owner.address))
            .to.eq(32000);

        await expect(Staking.connect(owner).claim(5))
            .to.be.revertedWith("too early");
        await expect(Staking.connect(acc1).claim(2))
            .to.be.revertedWith("too early");
        await network.provider.send("evm_increaseTime", [5300000]); // 23 Mar 2023 11:13:17
        await network.provider.send("evm_mine");

        console.log("acc1 balBefore", await TSTtoken.connect(owner).balanceOf(acc1.address));
        const te = await Staking.connect(acc1).claim(2);
        console.log("acc1 balAfterClaim", await TSTtoken.connect(owner).balanceOf(acc1.address));
        await te.wait();
        const tq = await getTimestamp(te.blockNumber)
        console.log(timeConverter(tq));
        // acc1 balBefore BigNumber { value: "70000" }   
        // acc1 balAfterClaim BigNumber { value: "80299" }
        // 10299 all, 10000 deposit, 299 profit

        await network.provider.send("evm_increaseTime", [94700000]); // 23 Mar 2026 11:7:36
        await network.provider.send("evm_mine");
        console.log(await TSTtoken.connect(owner).balanceOf(owner.address));
        const tr = await Staking.connect(owner).claim(5);
        await tr.wait();
        await expect(Staking.connect(owner).claim(5))
            .to.be.revertedWith("already receive");
        const ts = await getTimestamp(tr.blockNumber)
        console.log(timeConverter(ts));
        console.log(await TSTtoken.connect(owner).balanceOf(owner.address));
        // BigNumber { value: "68000" }
        // 23 Mar 2026 12: 1: 45
        // BigNumber { value: "85606" }  17606 all , 10000 deposit, 7606 profit

        await Staking.connect(owner).sendBackDeposit(owner.address, 4);
        console.log(await TSTtoken.connect(owner).balanceOf(owner.address));
        //BigNumber { value: "96639" } 11033 all, 8000 deposi, 3033 profit

    })
})

