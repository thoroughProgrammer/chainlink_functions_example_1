// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract FunctionsSource {
    string public getStarwarsCharacters =
        "const { ethers } = await import('npm:ethers@6.10.0');"
        "const abiCoder = ethers.AbiCoder.defaultAbiCoder();"
        "const characterId = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "    url: `https://swapi.info/api/people/${characterId}/`"
        "});"
        "if (apiResponse.error) {"
        "    console.log(res.error);"
        "    throw Error('Request failed');"
        "}"
        "const character = apiResponse.data.name;"
        "const height = parseInt(apiResponse.data.height);"
        "const encoded = abiCoder.encode([`string`, `string`, `uint256`], [characterId, character, height]);"
        "return ethers.getBytes(encoded);";
}
