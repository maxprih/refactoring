package org.bebra.dto.requests;

import lombok.Data;

/**
 * @author max_pri
 */
@Data
public class JwtRequest {
    private String login;
    private String password;
}
