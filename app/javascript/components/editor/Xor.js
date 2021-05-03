export default function xor(...arrs) {
    return arrs.reduce((acc, arr, i) => {
        let accSet = new Set(acc), // множество из элементов первого массива
            arrSet = new Set(arr); // множество из элементов второго массива
        return [...accSet].filter(a => !arrSet.has(a)) // элементы первого множества без элементо второго
            .concat( // объединение
                [...arrSet].filter(a => !accSet.has(a)) // элементы второго множества без элементов первого
            );
    }, []);
}