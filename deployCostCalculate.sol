contract deployCostCalculate{

    function gasCalculate (
        uint priceETHinUSD, //1700
        uint gasAmount,     //920000
        uint gasPriceInGwei //20
        ) external pure returns (uint costInUSDcents) {
            costInUSDcents = priceETHinUSD*gasAmount*gasPriceInGwei/10000000;
    }  
}
