"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isDescribe = exports.toStringLiteral = exports.filterMap = void 0;
/**
 * Applies the mapper over each element in the list.
 * If the mapper returns undefined it will not show up in the result
 *
 * @param list - array to filter + map
 * @param mapper - mapper func to apply to map
 */
function filterMap(list, mapper) {
    return list.reduce((res, val) => {
        const mappedVal = mapper(val);
        if (mappedVal !== undefined) {
            res.push(mappedVal);
        }
        return res;
    }, []);
}
exports.filterMap = filterMap;
/**
 * Escape value so that it can be go into single quoted string literal.
 * @param value
 */
function toStringLiteral(value) {
    return `'${value === null || value === void 0 ? void 0 : value.replace(/\\/g, '\\\\').replace(/'/g, "\\'")}'`;
}
exports.toStringLiteral = toStringLiteral;
function isDescribe(x) {
    if (!x) {
        return false;
    }
    if (x.type) {
        return true;
    }
    return false;
}
exports.isDescribe = isDescribe;
