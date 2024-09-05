CREATE OR REPLACE PROCEDURE CheckCarAvailability(
    IN p_car_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    car_status VARCHAR(20);
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    execution_time DOUBLE PRECISION;
BEGIN
    -- Captura o tempo de início
    start_time := clock_timestamp();

    -- Verificar o status do carro
    SELECT status INTO car_status
    FROM Cars
    WHERE id = p_car_id;

    -- Verificar se o carro existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Carro com ID % não encontrado.', p_car_id;
    END IF;

    -- Mensagem de disponibilidade
    IF car_status = 'disponível' THEN
        RAISE NOTICE 'Carro com ID % está disponível.', p_car_id;
    ELSE
        RAISE NOTICE 'Carro com ID % está atualmente %.', p_car_id, car_status;
    END IF;

    -- Captura o tempo de término
    end_time := clock_timestamp();

    -- Calcula o tempo de execução em milissegundos
    execution_time := EXTRACT(MILLISECOND FROM (end_time - start_time));
    RAISE NOTICE 'Tempo de execução da procedure: % ms', execution_time;
END;
$$;





CREATE OR REPLACE PROCEDURE CreateReservation(
    IN p_car_id INTEGER,
    IN p_customer_id INTEGER,
    IN p_pickup_date DATE,
    IN p_return_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    car_status VARCHAR(20);
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    execution_time DOUBLE PRECISION;
BEGIN
    -- Captura o tempo de início
    start_time := clock_timestamp();

    -- Verificar se o carro está disponível para o período solicitado
    IF EXISTS (
        SELECT 1
        FROM Reservations r
        WHERE r.car_id = p_car_id
          AND (r.pickup_date <= p_return_date AND r.return_date >= p_pickup_date)
    ) THEN
        RAISE EXCEPTION 'O carro ID % não está disponível para o período solicitado de % a %.',
            p_car_id, p_pickup_date, p_return_date;
    END IF;

    -- Verificar o status do carro
    SELECT status INTO car_status
    FROM Cars
    WHERE id = p_car_id;
    
    -- Permitir a reserva apenas se o carro estiver disponível
    IF car_status != 'available' THEN
        RAISE EXCEPTION 'O carro ID % está atualmente % e não pode ser reservado.',
            p_car_id, car_status;
    END IF;

    -- Inserir a nova reserva
    INSERT INTO Reservations (car_id, customer_id, pickup_date, return_date)
    VALUES (p_car_id, p_customer_id, p_pickup_date, p_return_date);

    -- Atualizar o status do carro para 'alugado'
    UPDATE Cars
    SET status = 'alugado'
    WHERE id = p_car_id;

    -- Captura o tempo de término
    end_time := clock_timestamp();

    -- Calcula o tempo de execução em milissegundos
    execution_time := EXTRACT(MILLISECOND FROM (end_time - start_time));
    RAISE NOTICE 'Tempo de execução da procedure: % ms', execution_time;

    RAISE NOTICE 'Reserva criada com sucesso para o carro ID %.',
        p_car_id;
END;
$$;




CREATE OR REPLACE PROCEDURE CancelReservation(
    IN p_car_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_reservation_id INTEGER;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    execution_time DOUBLE PRECISION;
BEGIN
    -- Captura o tempo de início
    start_time := clock_timestamp();

    -- Verificar se o carro está reservado
    SELECT id INTO v_reservation_id
    FROM Reservations
    WHERE car_id = p_car_id
      AND return_date >= CURRENT_DATE;  -- Verifica se a reserva ainda é válida

    -- Verificar se a reserva foi encontrada
    IF v_reservation_id IS NULL THEN
        RAISE EXCEPTION 'Nenhuma reserva encontrada para o carro ID %.', p_car_id;
    END IF;

    -- Atualizar o status do carro para 'disponível'
    UPDATE Cars
    SET status = 'available'
    WHERE id = p_car_id;

    -- Excluir a reserva
    DELETE FROM Reservations
    WHERE id = v_reservation_id;

    -- Captura o tempo de término
    end_time := clock_timestamp();

    -- Calcula o tempo de execução em milissegundos
    execution_time := EXTRACT(MILLISECOND FROM (end_time - start_time));
    RAISE NOTICE 'Tempo de execução da procedure: % ms', execution_time;

    RAISE NOTICE 'Reserva com ID % cancelada com sucesso e o carro ID % agora está disponível.',
        v_reservation_id, p_car_id;
END;
$$;



CALL CreateReservation(50, 500, '2024-09-10', '2024-09-15');
CALL CancelReservation(50);
CALL CheckCarAvailability(50);
