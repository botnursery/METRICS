// SPDX-License-Identifier: MIT
// smart contract to transfer Ethers to friends or relatives when we pass away v.0.1

pragma solidity >0.7.0 <0.9.0;

contract Will {
    address owner;							// owner of the contracts calls the contract manually and voluntarily
    uint256 legacy;		    				// number of Ethers that are going to be inherited
    uint256 payAfterTimestamp;				// anyone can execute the payment function but after a date preset by the owner timestamp since Unix epoch (1st Jan. 1970)
    address payable[] familyWallets;		// addresses of our friends and relatives that will inherit the Ethers
    mapping(address => uint256) inheritance;// hash-map mapping that includes the amounts to send to each wallet
    uint256 mywill;					// shows the amount of assets assigned for transfer
    uint256 surplus;				// shows the balance of the contract assets after transfer to the assigned addresses
    uint256 itstime;				// shows the timestamp of the blockchain block with the transfer record

// set the number of Ethers, the owner on the constructor of the contract, timestamp
    constructor(uint256 _payAfterTimestamp) payable {
        owner = msg.sender;
        legacy = msg.value;
        payAfterTimestamp = _payAfterTimestamp;
    }

// can be executed only by him
    modifier onlyOwner {
        require(msg.sender == owner,
                "Only the owner can execute this function");
        _;
    }

// let the owner set individually each address & each amount on a separate function
    function setInheritance(address payable _address, uint _value) public onlyOwner {
        require(legacy > (mywill + _value), "You are't soo much legacy");
        familyWallets.push(_address);
        inheritance[_address] += _value;
        mywill = mywill + inheritance[_address];
    }

// owner calls it & anyone calls it after the date preset by the owner
    function paytoout() public {
        require(msg.sender == owner || block.timestamp > payAfterTimestamp);
        for (uint i = 0; i < familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
            surplus = getBalance();
            itstime = block.timestamp;
        }
    }

// helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

// contract destructor
	function destroy(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
	}
}
