import { Describe } from 'joiDescribeTypes';
/**
 * Applies the mapper over each element in the list.
 * If the mapper returns undefined it will not show up in the result
 *
 * @param list - array to filter + map
 * @param mapper - mapper func to apply to map
 */
export declare function filterMap<T, K>(list: T[], mapper: (t: T) => K | undefined): K[];
/**
 * Escape value so that it can be go into single quoted string literal.
 * @param value
 */
export declare function toStringLiteral(value?: string): string;
export declare function isDescribe(x: unknown): x is Describe;
//# sourceMappingURL=utils.d.ts.map