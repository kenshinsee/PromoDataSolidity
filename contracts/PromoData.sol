// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract PromoData {

    struct Promo {
        string promoDesc;
        string promoParsedResult;
    }
    uint promoCount;
    // mapping(uint => Promo) data;
    Promo[] data;
    string description;
    address accountId;
    uint estimatedValue; // wei
    uint createTime = block.timestamp;
    address payable reciever;
    bool complete = false; // only allow to call saveData once

    constructor (string memory _description, 
                 uint _estimatedValue, 
                 address _accountId, 
                 address payable _reciever // set when deploy factory
                ) {
        description = _description;
        accountId = _accountId;
        reciever = _reciever;
        estimatedValue = _estimatedValue;
    }

    function saveData(string[] calldata promoDescList, 
                     string[] calldata promoParsedResultList
                    ) public payable {
        require(promoDescList.length == promoParsedResultList.length);
        require(!complete);
        for (uint i = 0; i < promoDescList.length; i++) {
            Promo storage promoData = data[i];
            promoData.promoDesc = promoDescList[i];
            promoData.promoParsedResult = promoParsedResultList[i];
        }
        promoCount = promoDescList.length;
        reciever.transfer(address(this).balance);
        complete = true;
    }

    function getPromoDataByIndex(uint index) public view returns(Promo memory) {
        return data[index];
    }

    function getPromoData() public view returns(Promo[] memory) {
        return data;
    }

    function getSummary() public view returns(
        string memory, address, address, uint, uint, uint, bool
    ) {
        return (
            description, 
            accountId, 
            reciever, 
            estimatedValue, 
            createTime, 
            promoCount, 
            complete
        );
    }

}