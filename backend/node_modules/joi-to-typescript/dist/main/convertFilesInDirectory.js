"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.convertFilesInDirectory = void 0;
const path_1 = __importDefault(require("path"));
const fs_1 = require("fs");
const write_1 = require("./write");
const analyseSchemaFile_1 = require("./analyseSchemaFile");
/**
 * Create types from schemas from a directory
 * @param settings Settings
 */
async function convertFilesInDirectory(appSettings, ogTypeOutputDir, fileTypesToExport = []) {
    // Check and resolve directories
    const resolvedSchemaDirectory = path_1.default.resolve(appSettings.schemaDirectory);
    if (!(0, fs_1.existsSync)(resolvedSchemaDirectory)) {
        throw new Error(`schemaDirectory "${resolvedSchemaDirectory}" does not exist`);
    }
    const resolvedTypeOutputDirectory = path_1.default.resolve(appSettings.typeOutputDirectory);
    if (!(0, fs_1.existsSync)(resolvedTypeOutputDirectory)) {
        (0, fs_1.mkdirSync)(resolvedTypeOutputDirectory, { recursive: true });
    }
    let fileNamesToExport = [];
    const currentDirFileTypesToExport = fileTypesToExport;
    // Load files and get all types
    const files = (0, fs_1.readdirSync)(resolvedSchemaDirectory);
    for (const schemaFileName of files) {
        const subDirectoryPath = path_1.default.join(resolvedSchemaDirectory, schemaFileName);
        if (!appSettings.rootDirectoryOnly && (0, fs_1.lstatSync)(subDirectoryPath).isDirectory()) {
            if (appSettings.ignoreFiles.includes(`${schemaFileName}/`)) {
                if (appSettings.debug) {
                    // eslint-disable-next-line no-console
                    console.debug(`Skipping ${subDirectoryPath} because it's in your ignore files list`);
                }
                continue;
            }
            const typeOutputDirectory = appSettings.flattenTree
                ? resolvedTypeOutputDirectory
                : path_1.default.join(resolvedTypeOutputDirectory, schemaFileName);
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
            const exportType = await (0, analyseSchemaFile_1.analyseSchemaFile)(appSettings, schemaFileName);
            if (exportType) {
                let dirTypeFileName = exportType.typeFileName;
                if (appSettings.indexAllToRoot) {
                    const findIndexEnd = resolvedTypeOutputDirectory.indexOf(ogTypeOutputDir) + ogTypeOutputDir.length + 1;
                    dirTypeFileName = path_1.default.join(resolvedTypeOutputDirectory.substring(findIndexEnd), (0, write_1.getTypeFileNameFromSchema)(schemaFileName, appSettings));
                }
                fileNamesToExport.push(dirTypeFileName);
                currentDirFileTypesToExport.push(exportType);
            }
        }
    }
    if (!appSettings.indexAllToRoot && !appSettings.flattenTree) {
        // Write index.ts
        (0, write_1.writeIndexFile)(appSettings, fileNamesToExport);
    }
    return { typeFileNames: fileNamesToExport, types: currentDirFileTypesToExport };
}
exports.convertFilesInDirectory = convertFilesInDirectory;
