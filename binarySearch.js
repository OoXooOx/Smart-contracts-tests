
function sortArray(arr) {
    return arr.map((item) => item).sort((a, b) => a - b); 
}

function getRandomUInt() {
    return Math.floor(Math.random() * 4294967296);
}

function generateRandomUIntArray(length) {
    const randomUIntArray = [];
    for (let i = 0; i < length; i++) {
        randomUIntArray.push(getRandomUInt());
    }
    return randomUIntArray;
}

const length = 2000;
const randomUIntArray = generateRandomUIntArray(length);
console.log(randomUIntArray);
const fiftyfive = sortArray(randomUIntArray)[55];
console.log(fiftyfive);

function binarySearch(arr, target) {
    let start = 0; // 3rd  3 
    let end = arr.length - 1;  // 1st 11    2nd  4         
    while (start <= end) {
        let mid = Math.floor((start + end) / 2); /// 1st 11/2=5.5=5     2nd 0+4/2=2      3rd (3+4)/2=3.5=3
        if (arr[mid] === target) { // 1st 9 !=5   2nd 3!=5   3rd 5==5
            return mid;
        }
        if (target < arr[mid]) {  // 1st 5<9     2nd 5<3
            end = mid - 1; // 1st 8
        } else {   // 
            start = mid + 1; // 3rd  start =3  
        }
    }
    return false;
}

const notSortedArray = [1, 3, 5, 7, 9, 29, 38, 2, 11, 13, 15, 17, 19];
const sortedArray = [1, 2, 3, 5, 7, 9, 11, 13, 15, 17, 19, 29, 38] 
const targetValue = 5;
const position = binarySearch(sortArray(notSortedArray), targetValue);
console.log("Position of target:", position);
// console.log(sortArray(notSortedArray));
// console.log(sortedArray);
const index = binarySearch(sortArray(randomUIntArray), fiftyfive);
console.log(index);


console.assert(binarySearch(sortArray(randomUIntArray), fiftyfive) === 55);
