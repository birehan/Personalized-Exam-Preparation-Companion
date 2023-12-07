import { AnySchema } from 'joi';
import { Settings, ConvertedType } from './types';
export { Settings };
export declare function convertSchema(settings: Partial<Settings>, joi: AnySchema, exportedName?: string, root?: boolean): ConvertedType | undefined;
/**
 * Create types from schemas from a directory
 *
 * @param settings - Configuration settings
 * @returns The success or failure of this operation
 */
export declare function convertFromDirectory(settings: Partial<Settings>): Promise<boolean>;
//# sourceMappingURL=index.d.ts.map