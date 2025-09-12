package at.fhv.SimpleBankingSystem.controller;

import at.fhv.SimpleBankingSystem.dto.AccountDTO;
import at.fhv.SimpleBankingSystem.service.AccountService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController("/api/accounts")
public class AccountController {
    private final AccountService accountService;

    public AccountController(AccountService accountService){
        this.accountService = accountService;
    }

    @GetMapping("/search")
    public AccountDTO getAccountByName(@RequestParam String name){
        return accountService.findAccountByName(name);
    }

    @PostMapping
    public ResponseEntity<String> createAccountByName(@RequestParam String name){
        try{
            AccountDTO accountDTO = accountService.createAccountByName(name);
            return ResponseEntity.status(HttpStatus.CREATED).body(accountDTO.toString());
        }catch(Exception e){
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Name already taken, try another name");
        }
    }

}
