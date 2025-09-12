package at.fhv.SimpleBankingSystem.service;


import at.fhv.SimpleBankingSystem.dto.AccountDTO;
import at.fhv.SimpleBankingSystem.model.Account;
import at.fhv.SimpleBankingSystem.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Optional;

@Service
public class AccountService {

    private final AccountRepository accountRepository;

    public AccountService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public AccountDTO findAccountByName(String name){
        Optional<Account> opt = accountRepository.findAccountByName(name);
        Account acc = opt.orElseThrow(() -> new RuntimeException("Account not found")) ;
        AccountDTO accDTO = new AccountDTO(acc.getName(),acc.getBalance());
        return accDTO;
    }

    public boolean findAccountByNameBool(String name){
        Optional<Account> opt = accountRepository.findAccountByName(name);
        if(!opt.isEmpty()){
            return true;
        }else{
            return false;
        }
    }

    public AccountDTO createAccountByName(String name){
        if(accountRepository.findAccountByName(name).isPresent()){
            throw new RuntimeException("Account name already exists");
        }
        Account acc = new Account();
        acc.setName(name);
        acc.setBalance(BigDecimal.ZERO);

        accountRepository.save(acc);
        return new AccountDTO(acc.getName(),acc.getBalance());
    }




}
