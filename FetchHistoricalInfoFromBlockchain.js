import { ethers } from "ethers";

const CONTRACT_ADDR = "YOUR_CONTRACT_ADDRESS";

const provider = new ethers.providers.JsonRpcProvider("YOUR_API_KEY");

export default function App() {

  const blockNumber25_07_2023 = 30194301;
  const blockNumber26_07_2023 = 30282703;
  const blockNumber19_07_2023 = 29589501; // approximately BSC mainnet
  const storageSlotIndex = 0; // Insert HERE the slot of YOUR search variable

  const getStorageAt = async () => {
    try {
      const storageValue = await provider.getStorageAt(CONTRACT_ADDR, storageSlotIndex, blockNumber25_07_2023);
      const decimalValue =  ethers.utils.formatEther(storageValue)
      console.log('Value at storage slot', storageSlotIndex, 'at block', blockNumber25_07_2023, ':', decimalValue);

      const storageValue1 = await provider.getStorageAt(CONTRACT_ADDR, storageSlotIndex, blockNumber26_07_2023);
      const decimalValue1 =  ethers.utils.formatEther(storageValue1)
      console.log('Value at storage slot', storageSlotIndex, 'at block', blockNumber26_07_2023, ':', decimalValue1);

      const storageValue2 = await provider.getStorageAt(CONTRACT_ADDR, storageSlotIndex, blockNumber19_07_2023);
      const decimalValue2 =  ethers.utils.formatEther(storageValue2)
      console.log('Value at storage slot', storageSlotIndex, 'at block', blockNumber19_07_2023, ':', decimalValue2);

    } catch (error) {
      console.error('Error:', error);
    }
  };
  
  return (
    <div >
        <button onClick={getStorageAt}>Get OldInfo</button></div>
    </div>
  );
}
