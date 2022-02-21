const main = async () => {
    //Creates a local ethereum network to run our contract on
    const waveContractFactory = await hre.ethers.getContractFactory(
        "WavePortal"
    );
    // People signed in on the network. Owner is the owner of the network (me)
    // random person is the guy that signed in to the network
    const [owner, randomPerson] = await hre.ethers.getSigners();

    // Deploys our contract to the local network. Returns our contract instance
    // Sends 0.1 ether to the contract
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();

    // the address where the contract was deployed to
    console.log("Contract deployed to:", waveContract.address);

    // the address of the owner of the contract
    console.log("Contract deployed to:", owner.address);

    let noOfWaves, waveTxn, listOfWavers;
    noOfWaves = await waveContract.getTotalWaves();
    console.log(noOfWaves.toNumber());

    /*
     * Get Contract balance before transaction
     */
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log("Contract balance before raw:", contractBalance);
    console.log(
        "Contract balance before:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    waveTxn = await waveContract.wave("I just waved chief");
    await waveTxn.wait();

    // waveTxn = await waveContract.wave("I just waved chief");
    // await waveTxn.wait();

    noOfWaves = await waveContract.getTotalWaves();

    /*
     * Get Contract balance after transaction
     */
    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log("Contract balance after raw:", contractBalance);
    console.log(
        "Contract balance after:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    // Prints the list of people that waved and the last waver
    listOfWavers = await waveContract.getListOfWavers();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0); // exit Node process without error
    } catch (error) {
        console.log(error.message);
        process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
};

runMain();
