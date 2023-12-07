"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.writeInterfaceFile = void 0;
const path_1 = __importDefault(require("path"));
const fs_1 = require("fs");
/**
 * Write interface file
 *
 * @returns The written file name
 */
async function writeInterfaceFile(settings, typeFileName, generatedTypes) {
    const generatedFile = generatedTypes.find(x => x.typeFileName === typeFileName);
    if (generatedFile && generatedFile.fileContent && generatedFile.typeFileName) {
        let typeImports = '';
        if (settings.flattenTree) {
            const externalTypeNames = generatedFile.externalTypes.map(typeToBeWritten => typeToBeWritten.customTypes).flat();
            typeImports = externalTypeNames.length == 0 ? '' : `import { ${externalTypeNames.join(', ')} } from '.';\n\n`;
        }
        else {
            const customTypeLocationDict = {};
            for (const externalCustomType of generatedFile.externalTypes
                .map(x => x.customTypes)
                .flat()
                .filter((value, index, self) => {
                // Remove Duplicates
                return self.indexOf(value) === index;
            })) {
                if (settings.indexAllToRoot) {
                    if (!customTypeLocationDict[settings.typeOutputDirectory]) {
                        customTypeLocationDict[settings.typeOutputDirectory] = [];
                    }
                    if (!customTypeLocationDict[settings.typeOutputDirectory].includes(externalCustomType)) {
                        customTypeLocationDict[settings.typeOutputDirectory].push(externalCustomType);
                    }
                }
                else {
                    for (const generatedInternalType of generatedTypes
                        .filter(f => f.typeFileName !== typeFileName)
                        .map(x => x.internalTypes)
                        .flat()
                        .filter((value, index, self) => {
                        return value.interfaceOrTypeName === externalCustomType && self.indexOf(value) === index;
                    })) {
                        if (generatedInternalType && generatedInternalType.location) {
                            if (!customTypeLocationDict[path_1.default.dirname(generatedInternalType.location)]) {
                                customTypeLocationDict[path_1.default.dirname(generatedInternalType.location)] = [];
                            }
                            if (!customTypeLocationDict[path_1.default.dirname(generatedInternalType.location)].includes(externalCustomType)) {
                                customTypeLocationDict[path_1.default.dirname(generatedInternalType.location)].push(externalCustomType);
                            }
                        }
                    }
                }
            }
            for (const customTypeLocation in customTypeLocationDict) {
                let relativePath = path_1.default.relative(generatedFile.typeFileLocation, customTypeLocation);
                relativePath = relativePath ? `${relativePath}` : '.';
                relativePath = relativePath.includes('..') || relativePath == '.' ? relativePath : `./${relativePath}`;
                typeImports += `import { ${customTypeLocationDict[customTypeLocation].join(', ')} } from '${relativePath.replace(/\\/g, '/')}';\n`;
            }
            if (typeImports) {
                typeImports += `\n`;
            }
        }
        const fileContent = `${settings.fileHeader}\n\n${typeImports}${generatedFile.fileContent}`;
        (0, fs_1.writeFileSync)(`${path_1.default.join(settings.flattenTree ? settings.typeOutputDirectory : generatedFile.typeFileLocation, typeFileName)}.ts`, fileContent);
        return generatedFile.typeFileName;
    }
    // This function is intended to only be called by `convertFromDirectory` where the input
    // data is checked before calling this function
    /* istanbul ignore next */
    return undefined;
}
exports.writeInterfaceFile = writeInterfaceFile;
