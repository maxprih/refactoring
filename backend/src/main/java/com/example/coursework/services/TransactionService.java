package com.example.coursework.services;

import com.example.coursework.models.entity.Transaction;
import com.example.coursework.models.entity.User;
import com.example.coursework.repositories.TransactionRepository;
import com.example.coursework.repositories.UserRepository;
import org.bebra.dto.TransactionDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.Instant;

/**
 * @author max_pri
 */
@Service
public class TransactionService {
    private final TransactionRepository transactionRepository;
    private final UserRetrievalService userRetrievalService;
    private final UserRepository userRepository;

    @Autowired
    public TransactionService(TransactionRepository transactionRepository, UserRetrievalService userRetrievalService, UserRepository userRepository) {
        this.transactionRepository = transactionRepository;
        this.userRetrievalService = userRetrievalService;
        this.userRepository = userRepository;
    }

    public Page<TransactionDto> getAllTransactions(Pageable pageable) {
        User user = userRetrievalService.getUserFromContext();

        Page<Transaction> transactions = transactionRepository.getTransactionByUserId(pageable, user.getId());

        return transactions.map(transaction -> {
            String type = transaction.getAmount() >= 0 ? "Пополнение" : "Убыток";

            return TransactionDto.builder()
                    .amount(transaction.getAmount())
                    .type(type)
                    .date(transaction.getDate())
                    .id(transaction.getId())
                    .build();
        });
    }

    public void createNewTransaction(Integer userId, Integer amount) {
        Transaction transaction = new Transaction();
        transaction.setAmount(amount);
        transaction.setDate(Instant.now());
        transaction.setUser(userRepository.findById(userId).get());

        transactionRepository.save(transaction);
    }

}
