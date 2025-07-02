-- Habilita a saída de mensagens no console
SET SERVEROUTPUT ON;
/

-- 1. ALTER TABLE
ALTER TABLE Ocorrencia ADD observacao_geral VARCHAR2(500);
/

-- 2. CREATE INDEX
CREATE INDEX idx_pessoa_nome ON Pessoa (nome);
/

-- 3. INSERT INTO
INSERT INTO Ocorrencia (protocolo, cep, numero, data, tipo, descricao, observacao_geral)
VALUES (ocorrencia_seq.nextval, '50000000', 400, TO_DATE('1985-03-19', 'YYYY-MM-DD'), 'Simulado de Resgate', 'Simulado de resgate em altura.', 'Equipe de treinamento.');
/

-- 4. UPDATE
UPDATE Ocorrencia
SET descricao = 'Incendio controlado, sem vitimas'
WHERE protocolo = 1;
/

-- 5. DELETE
DELETE FROM Ocorrencia
WHERE tipo = 'Simulado de Resgate';
/

-- 6. SELECT-FROM-WHERE
SELECT cpf, nome, data_nascimento
FROM Pessoa
WHERE data_nascimento > TO_DATE('1990-01-01', 'YYYY-MM-DD');
/

-- 7. BETWEEN
SELECT protocolo, data, tipo
FROM Ocorrencia
WHERE data BETWEEN TO_DATE('2025-06-21', 'YYYY-MM-DD') AND TO_DATE('2025-06-27', 'YYYY-MM-DD');
/

-- 8. IN
SELECT cpf, nome
FROM Pessoa
WHERE carteira_habilitacao IN ('A', 'B');
/

-- 9. LIKE
SELECT cpf, nome
FROM Pessoa
WHERE nome LIKE 'A%';
/

-- 10. IS NULL ou IS NOT NULL
SELECT cnpj, nome, complemento
FROM Quartel
WHERE complemento IS NULL;
/

-- 11. INNER JOIN
SELECT b.nome AS NomeBombeiro, q.nome AS NomeQuartel
FROM Pessoa b
INNER JOIN Bombeiro bb ON b.cpf = bb.cpf
INNER JOIN Quartel q ON bb.cnpj = q.cnpj;
/

-- 12. MAX
SELECT MAX(distancia_percorrida) AS MaiorDistancia
FROM UsoViatura;
/

-- 13. MIN
SELECT MIN(tempo_servico) AS MenorTempoServico
FROM Bombeiro;
/

-- 14. AVG
SELECT AVG(distancia_percorrida) AS DistanciaMedia
FROM UsoViatura;
/

-- 15. COUNT
SELECT COUNT(*) AS TotalOcorrencias
FROM Ocorrencia;
/

-- 16. LEFT ou RIGHT ou FULL OUTER JOIN
SELECT v.placa, v.tipo, mv.tipo AS TipoManutencao, mv.data AS DataManutencao
FROM Viatura v
LEFT JOIN ManutencaoViatura mv ON v.placa = mv.placa;
/

-- 17. SUBCONSULTA COM OPERADOR RELACIONAL
SELECT p.nome, b.tempo_servico
FROM Pessoa p
INNER JOIN Bombeiro b ON p.cpf = b.cpf
WHERE b.tempo_servico > (SELECT AVG(tempo_servico) FROM Bombeiro);
/

-- 18. SUBCONSULTA COM IN
SELECT cpf, nome
FROM Pessoa
WHERE cpf IN (
    SELECT a.cpf
    FROM Aciona a
    JOIN Ocorrencia o ON a.protocolo = o.protocolo
    WHERE o.tipo = 'Incendio Residencial'
    );
/

-- 19. SUBCONSULTA COM ANY
SELECT p.nome AS NomeSupervisor
FROM Pessoa p
INNER JOIN Bombeiro b ON p.cpf = b.cpf
WHERE b.cpf = ANY (
    SELECT supervisor
    FROM Supervisiona s
    JOIN Bombeiro sup ON s.supervisionado = sup.cpf
    WHERE sup.tempo_servico < 5
    );
/

-- 20. SUBCONSULTA COM ALL
SELECT v.placa, v.tipo
FROM Viatura v
WHERE v.placa = ALL (SELECT uv.placa FROM UsoViatura uv WHERE uv.distancia_percorrida > 16);
/

-- 21. ORDER BY
SELECT protocolo, data, tipo
FROM Ocorrencia
ORDER BY data DESC;
/

-- 22. GROUP BY
SELECT tipo, COUNT(*) AS Quantidade
FROM Viatura
GROUP BY tipo;
/

-- 23. HAVING
SELECT tipo, COUNT(*) AS TotalOcorrencias
FROM Ocorrencia
GROUP BY tipo
HAVING COUNT(*) > 2;
/

-- 24. UNION ou INTERSECT ou MINUS
SELECT cpf FROM Bombeiro
UNION
SELECT cpf FROM Vitima;
/

-- 25. CREATE VIEW
CREATE OR REPLACE VIEW vw_ocorrencias_com_cep AS
SELECT o.protocolo, o.data, o.tipo, o.descricao, c.rua, c.cidade
FROM Ocorrencia o
JOIN Cep c ON o.cep = c.cep;
/

-- Consulta a view
SELECT * FROM vw_ocorrencias_com_cep
WHERE cidade = 'Recife';
/

-- GRANT / REVOKE
-- "OBS.: O comando GRANT/REVOKE não é autorizado pelo Oracle Live SQL, então basta entender a função dele."

-- 26. USO DE RECORD
DECLARE
    TYPE r_pessoa IS RECORD (
        v_cpf Pessoa.cpf%TYPE,
        v_nome Pessoa.nome%TYPE,
        v_data_nascimento Pessoa.data_nascimento%TYPE
    );
    pessoa_info r_pessoa;
BEGIN
    SELECT cpf, nome, data_nascimento
    INTO pessoa_info
    FROM Pessoa
    WHERE cpf = '11111111111';

    DBMS_OUTPUT.PUT_LINE('Informações da Pessoa (RECORD):');
    DBMS_OUTPUT.PUT_LINE('CPF: ' || pessoa_info.v_cpf);
    DBMS_OUTPUT.PUT_LINE('Nome: ' || pessoa_info.v_nome);
    DBMS_OUTPUT.PUT_LINE('Data de Nascimento: ' || TO_CHAR(pessoa_info.v_data_nascimento, 'DD/MM/YYYY'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pessoa não encontrada.');
END;
/

-- 27. USO DE ESTRUTURA DE DADOS DO TIPO TABLE
DECLARE
    TYPE t_nomes_pessoas IS TABLE OF Pessoa.nome%TYPE INDEX BY PLS_INTEGER;
    v_nomes t_nomes_pessoas;
    v_contador NUMBER := 1;
BEGIN
    FOR p_rec IN (SELECT nome FROM Pessoa WHERE ROWNUM <= 5) LOOP
        v_nomes(v_contador) := p_rec.nome;
        v_contador := v_contador + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Nomes das Primeiras 5 Pessoas (TABLE):');
    FOR i IN 1 .. v_nomes.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Nome ' || i || ': ' || v_nomes(i));
    END LOOP;
END;
/

-- 28. BLOCO ANÔNIMO
DECLARE
    v_data_atual DATE := TO_DATE('2025-06-10', 'YYYY-MM-DD');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Data e Hora Atuais (Bloco Anônimo): ' || TO_CHAR(v_data_atual, 'DD/MM/YYYY HH24:MI:SS'));
END;
/

-- 29. CREATE PROCEDURE
CREATE OR REPLACE PROCEDURE RegistrarManutencaoViatura (
    p_codigo IN VARCHAR2,
    p_placa IN VARCHAR2,
    p_tipo IN VARCHAR2,
    p_data IN DATE,
    p_horario_atendimento IN VARCHAR2,
    p_observacoes IN VARCHAR2 DEFAULT NULL
)
IS
BEGIN
    INSERT INTO ManutencaoViatura (codigo, placa, tipo, data, horario_atendimento, observacoes)
    VALUES (p_codigo, p_placa, p_tipo, p_data, p_horario_atendimento, p_observacoes);
    DBMS_OUTPUT.PUT_LINE('Manutenção ' || p_codigo || ' para a viatura ' || p_placa || ' registrada com sucesso.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Manutenção com o mesmo código e placa já existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao registrar manutenção: ' || SQLERRM);
        ROLLBACK;
END RegistrarManutencaoViatura;
/

-- Executa a procedure
EXEC RegistrarManutencaoViatura('MANUT007', 'KGF1234', 'Preventiva', TO_DATE('2000-08-17', 'YYYY-MM-DD'), '08:00:00', 'Verificacao de rotina.');
/

-- 30. CREATE FUNCTION
CREATE OR REPLACE FUNCTION ObterNomePessoa (p_cpf IN VARCHAR2)
RETURN VARCHAR2
IS
    v_nome Pessoa.nome%TYPE;
BEGIN
    SELECT nome INTO v_nome
    FROM Pessoa
    WHERE cpf = p_cpf;
    RETURN v_nome;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Pessoa Não Encontrada';
    WHEN OTHERS THEN
        RETURN 'Erro: ' || SQLERRM;
END ObterNomePessoa;
/

-- Executa a function
DECLARE
    v_nome_pessoa VARCHAR2(255);
BEGIN
    v_nome_pessoa := ObterNomePessoa('11111111111');
    DBMS_OUTPUT.PUT_LINE('Nome da pessoa com CPF 11111111111: ' || v_nome_pessoa);

    v_nome_pessoa := ObterNomePessoa('99999999999');
    DBMS_OUTPUT.PUT_LINE('Nome da pessoa com CPF 99999999999: ' || v_nome_pessoa);

    v_nome_pessoa := ObterNomePessoa('00000000000');
    DBMS_OUTPUT.PUT_LINE('Nome da pessoa com CPF 00000000000: ' || v_nome_pessoa);
END;
/

-- 31. %TYPE
DECLARE
    v_tipo_ocorrencia Ocorrencia.tipo%TYPE;
    v_protocolo Ocorrencia.protocolo%TYPE := 1;
BEGIN
    SELECT tipo INTO v_tipo_ocorrencia
    FROM Ocorrencia
    WHERE protocolo = v_protocolo;
    DBMS_OUTPUT.PUT_LINE('Tipo da Ocorrência ' || v_protocolo || ': ' || v_tipo_ocorrencia);
END;
/

-- 32. %ROWTYPE
DECLARE
    ocorrencia_rec Ocorrencia%ROWTYPE;
BEGIN
    SELECT * INTO ocorrencia_rec
    FROM Ocorrencia
    WHERE protocolo = 2; -- Seleciona uma ocorrência existente

    DBMS_OUTPUT.PUT_LINE('Detalhes da Ocorrência (ROWTYPE):');
    DBMS_OUTPUT.PUT_LINE('Protocolo: ' || ocorrencia_rec.protocolo);
    DBMS_OUTPUT.PUT_LINE('Tipo: ' || ocorrencia_rec.tipo);
    DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR(ocorrencia_rec.data, 'DD/MM/YYYY'));
END;
/

-- 33. IF ELSIF
DECLARE
    v_grau_risco Vitima.grau_risco%TYPE := 'Alto';
BEGIN
    IF v_grau_risco = 'Grave' THEN
        DBMS_OUTPUT.PUT_LINE('Atenção máxima! Risco de vida iminente.');
    ELSIF v_grau_risco = 'Alto' THEN
        DBMS_OUTPUT.PUT_LINE('Risco elevado, atendimento prioritário.');
    ELSIF v_grau_risco = 'Medio' THEN
        DBMS_OUTPUT.PUT_LINE('Risco moderado, requer atenção.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Risco baixo, situação controlada.');
    END IF;
END;
/

-- 34. CASE WHEN
DECLARE
    v_estado_viatura Viatura.estado%TYPE := 'Em Manutencao';
    v_mensagem VARCHAR2(100);
BEGIN
    CASE v_estado_viatura
        WHEN 'Operacional' THEN
            v_mensagem := 'Viatura pronta para uso.';
        WHEN 'Em Manutencao' THEN
            v_mensagem := 'Viatura em manutenção, indisponível.';
        ELSE
            v_mensagem := 'Estado da viatura desconhecido.';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('Status da Viatura: ' || v_mensagem);
END;
/

-- 35. LOOP EXIT WHEN
DECLARE
    v_contador NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Exemplo de LOOP EXIT WHEN:');
    LOOP
        DBMS_OUTPUT.PUT_LINE('Iteração: ' || v_contador);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 5;
    END LOOP;
END;
/

-- 36. WHILE LOOP
DECLARE
    v_num_ocorrencias NUMBER := 0;
    v_protocolo Ocorrencia.protocolo%TYPE := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Exemplo de WHILE LOOP:');
    WHILE v_protocolo <= 5 LOOP
        SELECT COUNT(*) INTO v_num_ocorrencias
        FROM Ocorrencia
        WHERE protocolo = v_protocolo;

        IF v_num_ocorrencias > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Ocorrência ' || v_protocolo || ' existe.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Ocorrência ' || v_protocolo || ' não existe.');
        END IF;
        v_protocolo := v_protocolo + 1;
    END LOOP;
END;
/

-- 37. FOR IN LOOP
BEGIN
    DBMS_OUTPUT.PUT_LINE('Exemplo de FOR IN LOOP (Pessoas):');
    FOR p_rec IN (SELECT cpf, nome FROM Pessoa WHERE ROWNUM <= 3 ORDER BY nome) LOOP
        DBMS_OUTPUT.PUT_LINE('CPF: ' || p_rec.cpf || ', Nome: ' || p_rec.nome);
    END LOOP;
END;
/

-- 38. SELECT … INTO
DECLARE
    v_total_viaturas NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total_viaturas
    FROM Viatura;
    DBMS_OUTPUT.PUT_LINE('Total de Viaturas Registradas: ' || v_total_viaturas);
END;
/

-- 39. CURSOR (OPEN, FETCH e CLOSE)
DECLARE
    CURSOR c_quartel_info IS
        SELECT nome, comandante_responsavel
        FROM Quartel
        WHERE cidade = 'Recife';

    v_nome_quartel Quartel.nome%TYPE;
    v_comandante Quartel.comandante_responsavel%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Informações dos Quartéis em Recife (CURSOR):');
    OPEN c_quartel_info;
    LOOP
        FETCH c_quartel_info INTO v_nome_quartel, v_comandante;
        EXIT WHEN c_quartel_info%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Quartel: ' || v_nome_quartel || ', Comandante: ' || v_comandante);
    END LOOP;
    CLOSE c_quartel_info;
END;
/

-- 40. EXCEPTION WHEN
DECLARE
    v_protocolo Ocorrencia.protocolo%TYPE := 999;
    v_tipo_ocorrencia Ocorrencia.tipo%TYPE;
BEGIN
    SELECT tipo INTO v_tipo_ocorrencia
    FROM Ocorrencia
    WHERE protocolo = v_protocolo;
    DBMS_OUTPUT.PUT_LINE('Tipo da Ocorrência: ' || v_tipo_ocorrencia);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Ocorrência com protocolo ' || v_protocolo || ' não encontrada.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Mais de uma ocorrência encontrada para o protocolo ' || v_protocolo || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;
/

-- 41. USO DE PARÂMETROS (IN, OUT ou IN OUT)
CREATE OR REPLACE PROCEDURE AtualizarTempoServico (
    p_cpf IN VARCHAR2,
    p_incremento IN OUT NUMBER
)
IS
    v_tempo_antigo Bombeiro.tempo_servico%TYPE;
BEGIN
    SELECT tempo_servico INTO v_tempo_antigo
    FROM Bombeiro
    WHERE cpf = p_cpf;

    UPDATE Bombeiro
    SET tempo_servico = v_tempo_antigo + p_incremento
    WHERE cpf = p_cpf;

    p_incremento := v_tempo_antigo + p_incremento;
    DBMS_OUTPUT.PUT_LINE('Tempo de serviço do bombeiro ' || p_cpf || ' atualizado para ' || p_incremento || ' anos.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Bombeiro com CPF ' || p_cpf || ' não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar tempo de serviço: ' || SQLERRM);
        ROLLBACK;
END AtualizarTempoServico;
/

-- Executa a procedure
DECLARE
    v_cpf_bombeiro Bombeiro.cpf%TYPE := '22222222222';
    v_incremento_anos NUMBER := 2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Tempo de serviço antes: ' || v_incremento_anos);
    AtualizarTempoServico(v_cpf_bombeiro, v_incremento_anos);
    DBMS_OUTPUT.PUT_LINE('Novo tempo de serviço (retornado por IN OUT): ' || v_incremento_anos);
END;
/

-- 42. CREATE OR REPLACE PACKAGE
CREATE OR REPLACE PACKAGE PkgGerenciamentoBombeiros
IS
    PROCEDURE AdicionarBombeiro (
        p_cpf IN Pessoa.cpf%TYPE,
        p_nome IN Pessoa.nome%TYPE,
        p_data_nascimento IN Pessoa.data_nascimento%TYPE,
        p_carteira_habilitacao IN Pessoa.carteira_habilitacao%TYPE,
        p_cnpj_quartel IN Bombeiro.cnpj%TYPE,
        p_posto IN Bombeiro.posto%TYPE,
        p_tempo_servico IN Bombeiro.tempo_servico%TYPE,
        p_funcao IN Bombeiro.funcao%TYPE
    );

    FUNCTION ContarBombeirosPorQuartel (p_cnpj_quartel IN Quartel.cnpj%TYPE)
    RETURN NUMBER;

    PROCEDURE ListarBombeirosPorPosto (p_posto IN Bombeiro.posto%TYPE);

END PkgGerenciamentoBombeiros;
/

-- 43. CREATE OR REPLACE PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY PkgGerenciamentoBombeiros
IS
    PROCEDURE AdicionarBombeiro (
        p_cpf IN Pessoa.cpf%TYPE,
        p_nome IN Pessoa.nome%TYPE,
        p_data_nascimento IN Pessoa.data_nascimento%TYPE,
        p_carteira_habilitacao IN Pessoa.carteira_habilitacao%TYPE,
        p_cnpj_quartel IN Bombeiro.cnpj%TYPE,
        p_posto IN Bombeiro.posto%TYPE,
        p_tempo_servico IN Bombeiro.tempo_servico%TYPE,
        p_funcao IN Bombeiro.funcao%TYPE
    )
    IS
    BEGIN
        INSERT INTO Pessoa (cpf, nome, data_nascimento, carteira_habilitacao)
        VALUES (p_cpf, p_nome, p_data_nascimento, p_carteira_habilitacao);

        INSERT INTO Bombeiro (cpf, cnpj, posto, tempo_servico, funcao)
        VALUES (p_cpf, p_cnpj_quartel, p_posto, p_tempo_servico, p_funcao);

        DBMS_OUTPUT.PUT_LINE('Bombeiro ' || p_nome || ' (' || p_cpf || ') adicionado com sucesso.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CPF ' || p_cpf || ' já existe no sistema.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao adicionar bombeiro: ' || SQLERRM);
            ROLLBACK;
    END AdicionarBombeiro;

    FUNCTION ContarBombeirosPorQuartel (p_cnpj_quartel IN Quartel.cnpj%TYPE)
    RETURN NUMBER
    IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total
        FROM Bombeiro
        WHERE cnpj = p_cnpj_quartel;
        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Erro
    END ContarBombeirosPorQuartel;

    PROCEDURE ListarBombeirosPorPosto (p_posto IN Bombeiro.posto%TYPE)
    IS
        CURSOR c_bombeiros IS
            SELECT p.nome, b.cpf, b.tempo_servico, b.funcao
            FROM Pessoa p
            JOIN Bombeiro b ON p.cpf = b.cpf
            WHERE b.posto = p_posto;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Bombeiros com Posto ' || p_posto || ':');
        FOR rec IN c_bombeiros LOOP
            DBMS_OUTPUT.PUT_LINE('  Nome: ' || rec.nome || ', CPF: ' || rec.cpf || ', Tempo de Serviço: ' || rec.tempo_servico || ', Função: ' || rec.funcao);
        END LOOP;
        IF c_bombeiros%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Nenhum bombeiro encontrado para o posto ' || p_posto || '.');
        END IF;
    END ListarBombeirosPorPosto;

END PkgGerenciamentoBombeiros;
/

-- Usa o pacote
EXEC PkgGerenciamentoBombeiros.AdicionarBombeiro('16000000000', 'Novo Bombeiro', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'A', '00000000000101', 'Soldado', 0, 'Recem-Chegado');
/

DECLARE
    v_total_bombeiros NUMBER;
BEGIN
    v_total_bombeiros := PkgGerenciamentoBombeiros.ContarBombeirosPorQuartel('00000000000101');
    DBMS_OUTPUT.PUT_LINE('Total de bombeiros no Quartel Central de Recife: ' || v_total_bombeiros);
END;
/

EXEC PkgGerenciamentoBombeiros.ListarBombeirosPorPosto('Sargento');
/

-- 44. CREATE OR REPLACE TRIGGER (COMANDO)
CREATE OR REPLACE TRIGGER trg_log_ocorrencia_comando
BEFORE INSERT OR UPDATE OR DELETE ON Ocorrencia
DECLARE
    v_operacao VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERÇÃO';
    ELSIF UPDATING THEN
        v_operacao := 'ATUALIZAÇÃO';
    ELSIF DELETING THEN
        v_operacao := 'EXCLUSÃO';
    END IF;
    DBMS_OUTPUT.PUT_LINE('LOG (COMANDO): Operação de ' || v_operacao || ' na tabela Ocorrencia detectada por ' || USER);
END;
/

-- Testa o trigger de comando
INSERT INTO Ocorrencia (protocolo, cep, numero, data, tipo, descricao)
VALUES (ocorrencia_seq.nextval, '50000000', 500, TO_DATE('1986-04-20', 'YYYY-MM-DD'), 'Teste Trigger Comando', 'Teste de trigger de comando.');
/

UPDATE Ocorrencia SET descricao = 'Trigger atualizado.' WHERE tipo = 'Teste Trigger Comando';
/

DELETE FROM Ocorrencia WHERE tipo = 'Teste Trigger Comando';
/

-- 45. CREATE OR REPLACE TRIGGER (LINHA)
CREATE OR REPLACE TRIGGER trg_nova_viatura_linha
AFTER INSERT ON Viatura
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('LOG (LINHA): Nova viatura adicionada: Placa ' || :NEW.placa || ', Tipo ' || :NEW.tipo || ', Estado ' || :NEW.estado || '.');
END;
/

-- Testa o trigger de linha
INSERT INTO Viatura (placa, cnpj, tipo, estado)
VALUES ('TESTE01', '00000000000101', 'Carro de Apoio', 'Operacional');
/

DELETE FROM Viatura WHERE placa = 'TESTE01';
/

