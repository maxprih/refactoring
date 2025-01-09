package com.example.coursework.controllers;

import com.example.coursework.services.MatchService;
import org.bebra.dto.MatchDto;
import org.bebra.dto.requests.CreateMatchRequest;
import org.bebra.dto.responses.GetAllMatchesResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * @author max_pri
 */
@RestController
@RequestMapping("api/v1/matches")
@CrossOrigin(origins = "http://localhost:8081")
public class MatchController {
    private final MatchService matchService;

    @Autowired
    public MatchController(MatchService matchService) {
        this.matchService = matchService;
    }

    @GetMapping
    public ResponseEntity<GetAllMatchesResponse> getAllMatches() {
        return ResponseEntity.ok(matchService.getAllMatches());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MatchDto> getMatch(@PathVariable Integer id) {
        return ResponseEntity.ok(matchService.getMatchById(id));
    }

    @PostMapping()
    public ResponseEntity<?> create(@RequestBody CreateMatchRequest request) {
        matchService.create(request);

        return ResponseEntity.ok().build();
    }

}
