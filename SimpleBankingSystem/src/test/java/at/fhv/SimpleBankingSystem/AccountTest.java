package at.fhv.SimpleBankingSystem;

import at.fhv.SimpleBankingSystem.account.model.Account;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

class AccountTest {

    @Test
    void defaultBalanceShouldBeZero() {
        Account account = new Account();
        assertEquals(BigDecimal.ZERO, account.getBalance(),
                "Standardmäßig sollte der Kontostand 0 sein");
    }

    @Test
    void setAndGetNameShouldWork() {
        Account account = new Account();
        account.setName("TestKonto");

        assertEquals("TestKonto", account.getName(),
                "Der Name sollte korrekt gesetzt und zurückgegeben werden");
    }

    @Test
    void setAndGetBalanceShouldWork() {
        Account account = new Account();
        BigDecimal newBalance = new BigDecimal("123.45");

        account.setBalance(newBalance);

        assertEquals(newBalance, account.getBalance(),
                "Der Kontostand sollte korrekt gesetzt und zurückgegeben werden");
    }

    @Test
    void accountsWithSameValuesShouldBeEqual() {
        Account account1 = new Account();
        account1.setName("Konto1");
        account1.setBalance(new BigDecimal("50.00"));

        Account account2 = new Account();
        account2.setName("Konto1");
        account2.setBalance(new BigDecimal("50.00"));

        // Dank Lombok @Data: equals() und hashCode() automatisch
        assertEquals(account1, account2,
                "Zwei Accounts mit gleichen Werten sollten gleich sein");
    }
}