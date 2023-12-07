import { AnySchema } from 'joi';
import { Settings, ConvertedType, GenerateTypeFile } from './types';
export declare function convertSchemaInternal(settings: Settings, joi: AnySchema, exportedName?: string, rootSchema?: boolean): ConvertedType | undefined;
/**
 * Analyse a schema file
 *
 * @param settings - Settings
 * @param schemaFileName - Schema File Name
 * @returns Schema analysis results
 */
export declare function analyseSchemaFile(settings: Settings, schemaFileName: string): Promise<undefined | GenerateTypeFile>;
//# sourceMappingURL=analyseSchemaFile.d.ts.map