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
contract testSuite {
    Token tkn;
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        tkn = new Token();
    }

    function testTotalSupply() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(tkn.totalSupply(), 10000000000000000000000, 'token balance should be 10000 * 10 ** 18 initially');
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
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
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
        
    }
    
    function transferToAcc1() public {
        Assert.equal(balanceOf(acc0), 10000000000000000000000, 'initial value should be 10000 * 10 ** 18');
        transfer(acc1, 100000);
        Assert.equal(balanceOf(acc1), 100000, 'balances should be 10000');
        Assert.equal(balanceOf(acc0), 10000000000000000000000-100000, 'balances should have reduction of 100000 from initial value');
    }
    
    function transferToAcc2() public {
        Assert.equal(balanceOf(acc0), 10000000000000000000000-100000, 'should be same balances of acc0 in transferToAcc1');
        transfer(acc2, 200000);
        Assert.equal(balanceOf(acc2), 200000, 'balances should be 20000');
        Assert.equal(balanceOf(acc0), 10000000000000000000000-300000, 'balances should have reduction of 300000 from initial value');
    }
}

contract testDelegatedTransfer is Token {
    address acc0;
    address acc1;
    address acc2;
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
    }
    
    function transferFromAcc2ToAcc1() public {
        Assert.equal(balanceOf(acc0), 10000000000000000000000, 'initial value should be 10000 * 10 ** 18');
        approve(msg.sender,200000);
        transferFrom(acc0, acc1, 200000); //cannot more than approved amt
        Assert.equal(balanceOf(acc0), 10000000000000000000000-200000, 'balances should have reduction of 100000 from initial value');
        Assert.equal(balanceOf(acc1), 200000, 'acc1 should now have 200000');
    }
}
