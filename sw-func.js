const { ethers } = await import('npm:ethers@6.12.1');
// Importing Ethers.js library
// const { ethers } = require('ethers');


const abiCoder = ethers.AbiCoder.defaultAbiCoder();
// const abiCoder = ethers.utils.defaultAbiCoder;

const characterId = args[0];

const url = `https://swapi.dev/api/people/${characterId}/`;

const req = Functions.makeHttpRequest({
    url,
})

const res = await req;


if (res.error) {
    console.log(res.error);
    throw Error("Request failed");
}

console.log("res data available")

// console.log("response", res.data)

const character = res.data.name;
// const height = res.data.height;
const height = parseInt(res.data.height);

console.log(characterId)
console.log(character)
console.log(height)

const encoded = abiCoder.encode([`uint256`, `string`, `uint256`], [parseInt(characterId), character, height]);
// const encoded = abiCoder.encode([`string`, `string`, `string`], [characterId, character, height]);

return ethers.getBytes(encoded);
// return ethers.utils.arrayify(encoded);
// return Functions.encodeString(`${character} ${height}`);