package org.bebra.enums;

/**
 * @author max_pri
 */
public enum MatchEventStatus {
    WIN("win"),
    LOSE("lose"),
    TBD("tbd");

    public final String value;

    MatchEventStatus(String value) {
        this.value = value;
    }
}
