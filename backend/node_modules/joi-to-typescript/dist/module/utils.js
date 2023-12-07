/**
 * Applies the mapper over each element in the list.
 * If the mapper returns undefined it will not show up in the result
 *
 * @param list - array to filter + map
 * @param mapper - mapper func to apply to map
 */
export function filterMap(list, mapper) {
    return list.reduce((res, val) => {
        const mappedVal = mapper(val);
        if (mappedVal !== undefined) {
            res.push(mappedVal);
        }
        return res;
    }, []);
}
/**
 * Escape value so that it can be go into single quoted string literal.
 * @param value
 */
export function toStringLiteral(value) {
    return `'${value === null || value === void 0 ? void 0 : value.replace(/\\/g, '\\\\').replace(/'/g, "\\'")}'`;
}
export function isDescribe(x) {
    if (!x) {
        return false;
    }
    if (x.type) {
        return true;
    }
    return false;
}
