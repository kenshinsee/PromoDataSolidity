// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract PromoData {

    struct Promo {
        string promoDesc;
        string promoParsedResult;
    }
    uint promoCount;
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

    function saveData(string[] memory promoDescList, 
                      string[] memory promoParsedResultList
                     ) public payable {
        require(promoDescList.length == promoParsedResultList.length);
        require(!complete);
        require(msg.value >= estimatedValue);
        
        for (uint i = 0; i < promoDescList.length; i++) {
            Promo memory promoData;
            promoData.promoDesc = promoDescList[i];
            promoData.promoParsedResult = promoParsedResultList[i];
            data.push(promoData);
        }
        promoCount = promoDescList.length;
        complete = true;
    }

    function transferValue() public {
        require(msg.sender == reciever);
        reciever.transfer(address(this).balance);
    }

    function getPromoDataByIndex(uint index) public view returns(Promo memory) {
        return data[index];
    }

    function getPromoData() public view returns(Promo[] memory) {
        return data;
    }

    function getSummary() public view returns(
        string memory, address, address, uint, uint, uint, bool, uint
    ) {
        return (
            description, 
            accountId, 
            reciever, 
            estimatedValue, 
            createTime, 
            promoCount, 
            complete, 
            address(this).balance
        );
    }

}