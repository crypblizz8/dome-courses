// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.8.1;

contract Trust {
    struct Employee {
        uint amount;
        uint unlockDate;
        bool paid;
    }
    
    mapping(address => Employee) public employees;

    address public admin;
    
    constructor() {
        admin = msg.sender;
    }
    
    function addEmployee(address employee, uint unlockDate) external payable {
        require(msg.sender == admin, 'Only admin can add employees');
        require(employees[msg.sender].amount == 0, 'Employee exists'); // check if already added / stll dont get the index part 
        employees[employee] = Employee(msg.value, block.timestamp + unlockDate, false);
    }
    
    
    function withdraw() external {
        Employee storage employee = employees[msg.sender];
        
        require(employee.unlockDate <= block.timestamp, 'too early');
        require(employee.amount > 0, 'only employee can withdraw');
        require(employee.paid == false, 'already paid'); 
        employee.paid = true;
        payable(msg.sender).transfer(employee.amount);

    }

}