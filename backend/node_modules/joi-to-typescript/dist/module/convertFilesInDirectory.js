import Path from 'path';
import { existsSync, lstatSync, mkdirSync, readdirSync } from 'fs';
import { writeIndexFile, getTypeFileNameFromSchema } from './write';
import { analyseSchemaFile } from './analyseSchemaFile';
/**
 * Create types from schemas from a directory
 * @param settings Settings
 */
export async function convertFilesInDirectory(appSettings, ogTypeOutputDir, fileTypesToExport = []) {
    // Check and resolve directories
    const resolvedSchemaDirectory = Path.resolve(appSettings.schemaDirectory);
    if (!existsSync(resolvedSchemaDirectory)) {
        throw new Error(`schemaDirectory "${resolvedSchemaDirectory}" does not exist`);
    }
    const resolvedTypeOutputDirectory = Path.resolve(appSettings.typeOutputDirectory);
    if (!existsSync(resolvedTypeOutputDirectory)) {
        mkdirSync(resolvedTypeOutputDirectory, { recursive: true });
    }
    let fileNamesToExport = [];
    const currentDirFileTypesToExport = fileTypesToExport;
    // Load files and get all types
    const files = readdirSync(resolvedSchemaDirectory);
    for (const schemaFileName of files) {
        const subDirectoryPath = Path.join(resolvedSchemaDirectory, schemaFileName);
        if (!appSettings.rootDirectoryOnly && lstatSync(subDirectoryPath).isDirectory()) {
            if (appSettings.ignoreFiles.includes(`${schemaFileName}/`)) {
                if (appSettings.debug) {
                    // eslint-disable-next-line no-console
                    console.debug(`Skipping ${subDirectoryPath} because it's in your ignore files list`);
                }
                continue;
            }
            const typeOutputDirectory = appSettings.flattenTree
                ? resolvedTypeOutputDirectory
                : Path.join(resolvedTypeOutputDirectory, schemaFileName);
            const thisDirsFileNamesToExport = await convertFilesInDirectory({
                ...appSettings,
                schemaDirectory: subDirectoryPath,
                typeOutputDirectory
            }, ogTypeOutputDir, currentDirFileTypesToExport);
            if (appSettings.indexAllToRoot || appSettings.flattenTree) {
                fileNamesToExport = fileNamesToExport.concat(thisDirsFileNamesToExport.typeFileNames);
            }
        }
        else {
            if (!appSettings.inputFileFilter.test(schemaFileName)) {
                if (appSettings.debug) {
                    // eslint-disable-next-line no-console
                    console.debug(`Skipping ${schemaFileName} because it's excluded via inputFileFilter`);
                }
                continue;
            }
            if (appSettings.ignoreFiles.includes(schemaFileName)) {
                if (appSettings.debug) {
                    // eslint-disable-next-line no-console
                    console.debug(`Skipping ${schemaFileName} because it's in your ignore files list`);
                }
                continue;
            }
            const exportType = await analyseSchemaFile(appSettings, schemaFileName);
            if (exportType) {
                let dirTypeFileName = exportType.typeFileName;
                if (appSettings.indexAllToRoot) {
                    const findIndexEnd = resolvedTypeOutputDirectory.indexOf(ogTypeOutputDir) + ogTypeOutputDir.length + 1;
                    dirTypeFileName = Path.join(resolvedTypeOutputDirectory.substring(findIndexEnd), getTypeFileNameFromSchema(schemaFileName, appSettings));
                }
                fileNamesToExport.push(dirTypeFileName);
                currentDirFileTypesToExport.push(exportType);
            }
        }
    }
    if (!appSettings.indexAllToRoot && !appSettings.flattenTree) {
        // Write index.ts
        writeIndexFile(appSettings, fileNamesToExport);
    }
    return { typeFileNames: fileNamesToExport, types: currentDirFileTypesToExport };
}
