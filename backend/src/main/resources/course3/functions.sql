CREATE OR REPLACE FUNCTION is_express_bet(curr_bet_id INT)
    RETURNS BOOLEAN AS
$$
DECLARE
    event_count INT;
BEGIN
    SELECT COUNT(*)
    INTO event_count
    FROM Match_Event_Bet
    WHERE bet_id = curr_bet_id;

    RETURN event_count > 1;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION is_bet_won(curr_bet_id INT)
    RETURNS BOOLEAN AS
$$
DECLARE
    is_express   BOOLEAN := is_express_bet(curr_bet_id);
    event_status match_event_status;
BEGIN
    IF is_express THEN
        FOR event_status IN
            SELECT ME.status
            FROM Bet B
                     JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
                     JOIN Match_Event ME ON MEB.match_event_id = ME.id
            WHERE B.id = curr_bet_id
            LOOP
                IF event_status <> 'WIN' THEN
                    RETURN FALSE;
                END IF;
            END LOOP;

    ELSE
        IF EXISTS (SELECT ME.status
                   FROM Bet B
                            JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
                            JOIN Match_Event ME ON MEB.match_event_id = ME.id
                   WHERE B.id = curr_bet_id
                     AND ME.status <> 'WIN') THEN
            RETURN FALSE;
        END IF;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION has_bet_finished(curr_bet_id INT)
    RETURNS BOOLEAN AS
$$
DECLARE
    is_express   BOOLEAN := is_express_bet(curr_bet_id);
    event_status match_event_status;
BEGIN
    IF is_express THEN
        FOR event_status IN
            SELECT ME.status
            FROM Bet B
                     JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
                     JOIN Match_Event ME ON MEB.match_event_id = ME.id
            WHERE B.id = curr_bet_id
            LOOP
                IF event_status = 'LOSE' THEN
                    RETURN TRUE;
                END IF;
            END LOOP;
        RETURN FALSE;

    ELSE
        IF EXISTS (SELECT ME.status
                   FROM Bet B
                            JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
                            JOIN Match_Event ME ON MEB.match_event_id = ME.id
                   WHERE B.id = curr_bet_id
                     AND ME.status = 'TBD') THEN
            RETURN FALSE;
        END IF;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_total_coefficient(curr_bet_id INT)
    RETURNS DOUBLE PRECISION AS
$$
DECLARE
    total_coefficient DOUBLE PRECISION := 1;
    event_id          INT;
    bet_amount        INT;
    event_coefficient DOUBLE PRECISION;
BEGIN
    FOR event_id, bet_amount, event_coefficient IN
        SELECT MEB.match_event_id, B.amount, ME.coefficient
        FROM Bet B
                 JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
                 JOIN Match_Event ME ON MEB.match_event_id = ME.id
        WHERE B.id = curr_bet_id
        LOOP
            total_coefficient := total_coefficient * event_coefficient;
        END LOOP;

    RETURN total_coefficient;
END;
$$ LANGUAGE plpgsql;



-- CREATE OR REPLACE FUNCTION calculate_bet_winnings(curr_bet_id INT)
--     RETURNS DOUBLE PRECISION AS
-- $$
-- DECLARE
--     total_winnings    DOUBLE PRECISION := 0;
--     is_won            BOOLEAN          := is_bet_won(curr_bet_id);
--     total_coefficient DOUBLE PRECISION := calculate_total_coefficient(curr_bet_id);
--     bet_amount        INT;
-- BEGIN
--     If NOT is_won THEN
--         RETURN 0;
--     end if;
--
--     SELECT B.amount
--     INTO bet_amount
--     FROM Bet B
--              JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
--              JOIN Match_Event ME ON MEB.match_event_id = ME.id
--     WHERE B.id = curr_bet_id;
--
--     total_winnings := total_coefficient * bet_amount;
--
--     RETURN round(total_winnings::numeric, 2);
-- END;
-- $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_bet_winnings(curr_bet_id INTEGER) RETURNS DOUBLE PRECISION
    LANGUAGE plpgsql
AS $$
DECLARE
    total_winnings    DOUBLE PRECISION := 0;
    bet_status        bet_status;
    total_coefficient DOUBLE PRECISION := calculate_total_coefficient(curr_bet_id);
BEGIN
    -- Get the bet status
    SELECT status
    INTO bet_status
    FROM Bet
    WHERE id = curr_bet_id;

    CASE bet_status
        WHEN 'WIN' THEN
            total_winnings := total_coefficient * (SELECT amount FROM Bet WHERE id = curr_bet_id);
        WHEN 'LOSE' THEN
            total_winnings := -1 * (SELECT amount FROM Bet WHERE id = curr_bet_id);
        ELSE
            total_winnings := 0;
        END CASE;

    RETURN round(total_winnings::NUMERIC, 2);
END;
$$;

-- Change the function owner if necessary
    ALTER FUNCTION calculate_bet_winnings(INTEGER) OWNER TO max_pri;


CREATE OR REPLACE FUNCTION get_matches_within_24_hours()
    RETURNS TABLE
            (
                match_id   INT,
                match_date TIMESTAMP
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT id, date
        FROM Match
        WHERE date >= NOW()
          AND date <= NOW() + INTERVAL '24 hours';
END;
$$ LANGUAGE plpgsql;


-- trigger
CREATE OR REPLACE FUNCTION check_match_date_within_league_date()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.date < (SELECT start_date FROM League WHERE id = NEW.league_id) OR
       NEW.date > (SELECT end_date FROM League WHERE id = NEW.league_id) THEN
        RAISE EXCEPTION 'Match date is outside the league date range';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_bet_status()
    RETURNS TRIGGER AS
$$
DECLARE
    bet_ids      INT[];
    curr_bet_id  INT;
    final_status bet_status;
BEGIN
    SELECT ARRAY(
                   SELECT bet_id
                   FROM Match_Event_Bet
                   WHERE match_event_id = NEW.id
               )
    INTO bet_ids;

    FOREACH curr_bet_id IN ARRAY bet_ids
        LOOP
            RAISE NOTICE 'bet_id %', curr_bet_id;
            IF is_bet_won(curr_bet_id) THEN
                final_status := 'WIN'::bet_status;
            ELSE
                IF has_bet_finished(curr_bet_id) THEN
                    final_status := 'LOSE'::bet_status;
                ELSE
                    final_status := 'TBD'::bet_status;
                END IF;
            END IF;

            UPDATE Bet
            SET status = final_status
            WHERE id = curr_bet_id;
        END LOOP;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_match_with_events_for_bet(curr_bet_id INT)
    RETURNS TABLE
            (
                match_id                INT,
                match_date              TIMESTAMP,
                match_event_id          INT,
                match_event_name        TEXT,
                match_event_status      match_event_status,
                match_event_coefficient DOUBLE PRECISION
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT M.id, M.date, ME.id, ME.name, ME.status, ME.coefficient
        FROM Bet B
                 JOIN Match_Event_Bet MEB ON B.id = MEB.bet_id
                 JOIN Match_Event ME ON MEB.match_event_id = ME.id
                 JOIN Match M ON ME.match_id = M.id
        WHERE B.id = curr_bet_id;
END;
$$ LANGUAGE plpgsql;


-- trigger
CREATE OR REPLACE FUNCTION check_bet_amount()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.amount <= (SELECT amount
                      FROM Balance
                      WHERE user_id = NEW.user_id) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Bet amount exceeds user balance';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- trigger
CREATE OR REPLACE FUNCTION update_user_balance()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'WIN' THEN
        UPDATE Balance
        SET amount = amount + calculate_bet_winnings(NEW.id)
        WHERE user_id = NEW.user_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;




