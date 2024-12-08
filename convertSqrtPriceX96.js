function sqrtPriceX96ToPrice( sqrtPriceX96, token0Decimals, token1Decimals, lookingForToken0Price) {
    let finalPrice;
    let price = parseInt(sqrtPriceX96) / Math.pow(2, 96);
    price = price * price;
    if (lookingForToken0Price) {
        const decimals = 10 ** (token0Decimals - token1Decimals);
        finalPrice = price * decimals;
    } else {
        const invertedPrice = 1 / price;
        const decimals = 10 ** (token1Decimals - token0Decimals);
        finalPrice = invertedPrice * decimals;
    }
    return finalPrice;
};

function priceToSqrtPriceX96(price, token0Decimals, token1Decimals, lookingForToken0Price) {
    let sqrtPriceX96;
    if (lookingForToken0Price) {
        const decimals = 10 ** (token0Decimals - token1Decimals);
        const adjustedPrice = price / decimals;
        sqrtPriceX96 = Math.sqrt(adjustedPrice) * Math.pow(2, 96);
    } else {
        const decimals = 10 ** (token1Decimals - token0Decimals);
        const adjustedPrice = 1 / (price / decimals);
        sqrtPriceX96 = Math.sqrt(adjustedPrice) * Math.pow(2, 96);
    }
    return BigInt(sqrtPriceX96).toString(); 
}


console.log(priceToSqrtPriceX96("5000", 18, 6, true));
console.log(sqrtPriceX96ToPrice("5602277097478614115418112", 18, 6, true));
