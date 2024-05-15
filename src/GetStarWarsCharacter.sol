// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract ChainLinkFunctionsNew is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    // Custom error type
    error UnexpectedRequestID(bytes32 requestId);
    error InvalidRouter(address router);
    error LatestVerifiedKYCRequestNotYetFulfilled();

    // Event to log responses
    event Response(
        bytes32 indexed requestId,
        CharacterDetails characterDetails,
        bytes response,
        bytes err
    );

    struct CharacterDetails {
        string character;
        uint256 height;
    }

    CharacterDetails internal characterDetails;
    string s_getStarWarsCharacterSource

    // Hardcoded for Fuji
    // Supported networks https://docs.chain.link/chainlink-functions/supported-networks
    address router = 0xA9d587a00A31A52Ed70D6026794a8FC5E2F5dCb0;
    bytes32 donID =
        0x66756e2d6176616c616e6368652d66756a692d31000000000000000000000000;

    //Callback gas limit
    uint32 gasLimit = 300000;

    uint64 subscriptionId;

    bytes32 internal s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    mapping(string characterId => CharacterDetails) public s_characterDetails;

    constructor(uint64 functionSubscriptionId, , string memory getStarWarsCharacterSource) FunctionsClient(router) {
        subscriptionId = functionSubscriptionId;
        s_getStarWarsCharacterSource = getStarWarsCharacterSource;
    }

    function sendRequest(
        string memory _characterId
    ) external returns (bytes32 requestId) {
        if (s_lastRequestId != bytes32(0))
            revert LatestVerifiedKYCRequestNotYetFulfilled();

        string[] memory args = new string[](1);
        args[0] = _characterId;

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(
            s_getStarWarsCharacterSource
        ); // Initialize the request with JS code
        if (args.length > 0) req.setArgs(args); // Set the arguments for the request

        // Send the request and store the request ID
        requestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            gasLimit,
            donID
        );

        // return s_lastRequestId;
    }

    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }
        // Update the contract's state variables with the response and any errors
        (
            string memory characterId,
            string memory character,
            uint256 height
        ) = abi.decode(response, (string, string, uint256));
        s_lastResponse = response;
        characterDetails = CharacterDetails({
            character: character,
            height: height
        });
        s_characterDetails[characterId] = characterDetails;
        s_lastError = err;

        // Emit an event to log the response
        emit Response(requestId, characterDetails, s_lastResponse, s_lastError);

        s_lastRequestId = bytes32(0);
    }
}
