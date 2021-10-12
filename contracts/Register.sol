/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
contract Register 

{
    using Counters for Counters.Counter;
    Counters.Counter private _idCounter;



    enum UserStatus {
        NotActive,
        banned,
        Active,
        Suspend
    }

    struct User {
        uint256 userId;
        address userAddress;
        string profilePic;
        string Alias;
        UserStatus status;
    }
    mapping(string => bool) private userAlias;
    mapping(address => User) userDetails;
    modifier onlyRegisteredUser(address _userAddress) {
        User memory details = userDetails[_userAddress];
        require(details.status == UserStatus.Active, "User not registered yet");

        _;
    }
    event UserAdded(uint256, address);


    /// @dev Increment and get the counter, which is used as the unique identifier for post
    /// @return The unique identifier
    function incrementAndGet() internal virtual  returns (uint256) {
        _idCounter.increment();
        return _idCounter.current();
    }

    //*************************************RegisterUsers**************************************************//

    /// @notice Emitted when any post is reported for violation
    /// @param _profilePic Profile image of user, will be stored on ipfs
    /// @param _alias Alias here is for unique user name
    function RegisterUsers(string memory _profilePic, string memory _alias)
        external
    {
        bool isUser = isUserExists(msg.sender);
        require(!isUser, "User already registered");
        require(!userAlias[_alias], "Not avaliable");
        userAlias[_alias] = true;
        uint256 userId = incrementAndGet();

        User memory users = User(
            userId,
            msg.sender,
            _profilePic,
            _alias,
            UserStatus.Active
        );
        userDetails[msg.sender] = users;

        //               userById[users.userId] = users;

        emit UserAdded(userId, msg.sender);
    }

    /// @notice Check whethe user exist or not, return boolean value
    /// @param _userAddress address of the user
    function isUserExists(address _userAddress) public view returns (bool) {
        User memory details = userDetails[_userAddress];
        if (details.status == UserStatus.Active) return (true);

        return (false);
    }

    /// @notice Allows user to delete their info
    function deleteUsers() public onlyRegisteredUser(msg.sender) {
        delete userDetails[msg.sender];
        //  userAlias[userDetails[msg.sender].Alias=false;
    }
     function SuspendUser(address _userAddress) public view {
        User memory details = userDetails[_userAddress];

        details.status == UserStatus.Active;
    }
    function BanUser(address _userAddress) public {
                User memory details = userDetails[_userAddress];
                        delete userDetails[_userAddress];

        details.status == UserStatus.Active;

    }
}
