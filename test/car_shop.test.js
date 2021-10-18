const BigNumber = require('bignumber.js');
const truffleAssert = require('truffle-assertions');

function expandTo18Decimals(n) {
    return BigNumber(n * Math.pow(10, 18))
}

const CarShop = artifacts.require('CarShop');

contract("CarShop", accounts => {
    const acc1 = accounts[0]
    const acc2 = accounts[1]

    it('owner should add a car', async () => {
        const shop = await CarShop.deployed()
        const price = expandTo18Decimals(1)

        assert.equal(await shop.carsCount(), 0)
        assert.equal(await shop.carsIndexes(acc2), 0)

        await shop.addCar(acc2, price)

        assert.equal(await shop.carsCount(), 1)
        assert.equal(await shop.carsIndexes(acc2), 1)
    });

    it('should not add a car when unauthorized', async () => {
        const shop = await CarShop.deployed()
        const price = expandTo18Decimals(1)

        await truffleAssert.reverts(
            shop.addCar(acc2, price, {from: acc2}),
            "NOT_AUTHORIZED"
        )
    });

    it('should not add an existing car', async () => {
        const shop = await CarShop.deployed()
        const price = expandTo18Decimals(1)

        await truffleAssert.reverts(
            shop.addCar(acc2, price),
            "CAR_ALREADY_EXISTS"
        )
    });

    it('should not buy with insufficient amount', async () => {
        const shop = await CarShop.deployed()
        const price = new BigNumber(10)

        await truffleAssert.reverts(
            shop.buy(acc2, {from: acc2, value: price}),
            "INSUFFICIENT_AMOUNT"
        )
    });

    it('should buy', async () => {
        const shop = await CarShop.deployed()
        const price = expandTo18Decimals(1)

        const acc1BalanceBefore = await web3.eth.getBalance(acc1)

        await shop.buy(acc2, {from: acc2, value: price})

        const acc1BalanceAfter = await web3.eth.getBalance(acc1)

        assert.equal(await shop.salesCount(), 1)
        assert.equal(await shop.carsCount(), 0)
        assert.equal(await shop.carsIndexes(acc2), 0)
        assert.isTrue(parseInt(acc1BalanceAfter) - parseInt(acc1BalanceBefore) == price)
    });

    it('should not buy an inexistant car', async () => {
        const shop = await CarShop.deployed()
        const price = expandTo18Decimals(1)

        await truffleAssert.reverts(
            shop.buy(acc2, {from: acc2, value: price}),
            "CAR_NOT_FOUND"
        )
    });
});