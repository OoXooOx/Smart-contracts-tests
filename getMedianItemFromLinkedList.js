/**
 * Find a middle/median element of given Linked List.
 *
 * @param {Object} list - Linked List
 * @example
 * { data: 1, 
 * next: { data: 2, next: null } 
 * }
 * Cвязанный список это объект JS {} c полями data - инфа и next - вложенный объект который содержит 
 * следующую пару data/next и т.д.
 * 
 * @return {Object} reference to node which is middle element of given list
 */
function getMedianItem ( list ) {
    let current = list;  // присвоили значение объекта list переменной current
    let length = 0;  // ввели значение длинны связанного массива(объекта)
    while(current) {  // пока current равно true. Как только доходим до последнего вложенного объекта,
        //то получаем поле next=null==false=>Выходим из while цикла
        current = current.next; // модифицируем current и говорим что она будет равна current.next 
        length++;   // увеличиваем величину длинны на 1
    }
    let lengthHalf=length/2; // определяем середину длинны
    const roundedNumberMedian = Math.floor(lengthHalf);// округляем середину длинны до меньшего значения
    let current1=list; // опять присваем переменной current1 значение объекта list
    let index=0;   // вводим новый индекс, который будем увеличивать
    while(index<roundedNumberMedian){ // пока индекс меньше высчитанной и округленной медианы
        current1=current1.next; // делаем присваивание переменной current1 содержимого поля next
        index++;
    }
    return current1; // возвращаем искомый объект
    // your awesome code here
    // 
 }
 
 // driver code Вспомогательный для теста код
 const node = (data, next) => ({data, next});

 const createSingleLinkedList = (dataset) => {
    return dataset.reduceRight( (head, item) => node(item, head), null);
 };

console.log(
    getMedianItem(createSingleLinkedList([100, 0, 1, 3, 2022]))
);


//  console.log( 
//     createSingleLinkedList([100, 0, 1]),
//  );

 // tests
 //  Мы должны передать массив [100, 0, 1, 3, 2022] в функцию createSingleLinkedList() =>
 // потом полученый объект мы передаем в функцию getMedianItem(), получаем ответ и берем
 // через . поле data и сравниваем === с 1. И если получаем true, то тест проходит.
 console.assert(getMedianItem(createSingleLinkedList([100, 0, 1, 3, 2022])).data === 1);
 console.assert(getMedianItem(createSingleLinkedList(['foo', 'bar'])).data === 'bar');
 console.assert(getMedianItem(createSingleLinkedList([1, 2, 3, 4, 5, 6, 7])).data === 4);
 console.assert(getMedianItem(createSingleLinkedList([1000, 2000, 4000, 0])).data === 4000);
 
//  next.data
//  let list = { 
//    data: 100, 
//    next: {
//      data: 0,
//      next: {
//          data: 1,
//          next: {
//              data: 3,
//              next: {
//                  data: 2022,
//                  next: null
//              }
//          }
//      }
//    }
//  }
 
