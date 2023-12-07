import { TypeContent, Settings } from './types';
import { Describe } from './joiDescribeTypes';
export declare const supportedJoiTypes: string[];
export declare function getAllCustomTypes(parsedSchema: TypeContent): string[];
export declare function typeContentToTs(settings: Settings, parsedSchema: TypeContent, doExport?: boolean): string;
/**
 * Parses a joi schema into a TypeContent
 * @param details: the joi schema
 * @param settings: settings used for parsing
 * @param useLabels if true and if a schema has a label we won't parse it and instead just reference the label in the outputted type
 * @param ignoreLabels a list a label to ignore if found. Sometimes nested joi schemas will inherit the parents label so we want to ignore that
 * @param rootSchema
 */
export declare function parseSchema(details: Describe, settings: Settings, useLabels?: boolean, ignoreLabels?: string[], rootSchema?: boolean): TypeContent | undefined;
//# sourceMappingURL=parse.d.ts.map