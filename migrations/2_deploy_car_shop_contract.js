const CarShop = artifacts.require('CarShop');

module.exports = async function (deployer) {
    await deployer.deploy(CarShop);
    console.log('Deployed', CarShop.address);
  };