const { expect, chai } = require("chai");
const { ethers } = require("hardhat");

const { sqrt } = require('mathjs')
// describe("Payments", function () {
//     let owner;
//     let receiver;
//     let receiver2;
//     let payments;
//     let someacc;

//     beforeEach(async function () {
//         [owner, receiver, someacc, receiver2] = await ethers.getSigners()
//         const Payments = await ethers.getContractFactory("Payments", owner)
//         payments = await Payments.deploy(owner.address, {
//             value: ethers.utils.parseUnits("100", 0)
//         })
//         await payments.deployed()

//     })

//     it("should allow to send and receive payments", async function () {

//        console.log(owner);

//         expect (await payments.chain()).to.eq(1337);
//     });





// });


describe("b", function () {
    let owner;

    beforeEach(async function () {
        [owner] = await ethers.getSigners()
        const B = await ethers.getContractFactory("b", owner)
        bs = await B.deploy()
        await bs.deployed()


    })

    it("should allow to send and receive payments", async function () {
        const A = await ethers.getContractFactory("a", owner)
        as = await A.deploy(bs.address)
        await as.deployed()
        console.log(as.address, bs.address);
        const sum = ethers.utils.parseEther("2.0")
        // const sum = ethers.utils.parseEther("0.0001")
        
        const tr = await as.connect(owner).deposit({ value: sum })
        await tr.wait()
        expect(await ethers.provider.getBalance(as.address)).to.eq(sum)
        console.log( await owner.getBalance());
        console.log(await ethers.provider.getBalance(as.address));
        console.log(sum);
        // const sum2 = ethers.BigNumber.from("2000000000000000000")
        // console.log(sum2);
        // await expect(await as.connect(owner).deposit({ value: sum }))
        //     .to.changeEtherBalances([owner, as], [-sum, sum]);
        console.log(await bs.connect(owner).count());
        const tu = await as.connect(owner).withdraw()
        await tu.wait()
        expect(await bs.connect(owner).count())
        .to.eq(1);
        const sum3 = ethers.BigNumber.from(1000000000000000000n)
        expect(await ethers.provider.getBalance(bs.address)).to.eq(sum3) 
        // console.log(sqrt(-4).toString())

        // console.log(await as.count());
        // expect.tr.to.changeEtherBalances([owner, as], [-sum, sum])

        //  expect (await payments.chain()).to.eq(1337);
    });




})