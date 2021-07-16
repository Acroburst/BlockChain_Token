// SPDX-License-Identifier: GPL-3.0
    
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../Token.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testInitialisation {
    Token tkn;
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        tkn = new Token();
    }

    function testTotalSupply() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(tkn.totalSupply(), 10000000000000000000000, 'token supply should be 10000 * 10 ** 18 initially');
    }
    
    function testSymbol() public {
        Assert.equal(tkn.symbol(), "TKN", 'symbol should be TKN');
    }
    
    function testName() public {
        Assert.equal(tkn.name(), "My Token", 'name should state My Token');
    }
    
    function testDecimals() public {
        Assert.equal(tkn.decimals(), 18, 'decimals should be 18');
    }
    
}

contract testTransfer is Token {
   
    address acc0;
    address acc1;
    address acc2;
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        //Max Limit is 3 test accounts before remix-ide release v0.10.0 
        acc0 = TestsAccounts.getAccount(0); //owner by default
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
    }
    
    function testInitialOwner() public {
        Assert.ok(msg.sender == acc0, 'caller should be default account i.e. acc0');
        Assert.equal(balanceOf(msg.sender), totalSupply, 'owner should have all tokens'); //test for constructor function in contract
        Assert.equal(balanceOf(acc1), 0, 'no other holders have tokens at first i.e. acc1'); 
        Assert.equal(balanceOf(acc2), 0, 'no other holders have tokens at first i.e. acc2');
    }
    
    function transferToAcc1() public  {
        Assert.equal(balanceOf(acc0), 10000000000000000000000, 'initial value should be 10000 * 10 ** 18');
        transfer(acc1, 100000);
        Assert.equal(balanceOf(acc1), 100000, 'balances should be 100000');
        Assert.equal(balanceOf(acc0), 10000000000000000000000-100000, 'balances should have reduction of 100000 from initial value');
    }
    
    function transferToAcc2() public  {
        Assert.equal(balanceOf(acc0), 10000000000000000000000-100000, 'should be same balances of acc0 in transferToAcc1');
        transfer(acc2, 200000);
        Assert.equal(balanceOf(acc2), 200000, 'balances should be 200000');
        Assert.equal(balanceOf(acc0), 10000000000000000000000-300000, 'balances should have reduction of 300000 from initial value');
    }
    
    function testApproval() public {
        approve(acc2, 200000);
        //test for approve function in contract, if allowance array (spender & value) are declared correctly
        Assert.ok(allowance[msg.sender][acc2] == 200000, 'approved value does not match allowance value'); 
    }
    function transferFromAcc2ToAcc1() public  {
        //transferFrom(acc0, acc1, 200000); //cannot more than approved amt, otherwise transaction will be reverted
       
        
    }
}