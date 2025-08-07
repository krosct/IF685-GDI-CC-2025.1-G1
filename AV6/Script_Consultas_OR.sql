-- SCRIPT PARA CONSULTAS OR

-- 4 primeiras consultas completam o checklist dado.

--  Como usamos uma organização onde temos uma tabela de pessoas que é supertipo, em vez de ter várias
-- tabelas para cada subtipo, usamos de TREAT para acessar a referência do quartel a partir da tabela de pessoas.

-- Retornar OID do quartel associado a cada bombeiro:
SELECT p.nome AS nome_bombeiro,
       REFTOHEX(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref) AS referencia_quartel
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro);
/*
Só para deixar claro o conhecimento, o uso direto de REF com um tb_bombeiros seria algo tipo:
SELECT b.nome AS nome_bombeiro,
       REFTOHEX(REF(b)) AS referencia_bombeiro
FROM tb_bombeiro b;
*/

-- Retornar dados todos bombeiros com mais de 5 anos de serviço 
-- Sendo seu nome, anos de serviço, quartel, e comandante responsável:
-- Exemplo de DEREF. Aqui também precisamos usar TREAT para acessar o subtipo tp_bombeiro.
SELECT p.nome AS nome_bombeiro, 
    TREAT(VALUE(p) AS tp_bombeiro).tempo_servico AS anos_servico,
    DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).nome AS nome_quartel,
    DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).comandante_responsavel AS comandante
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro);
  --AND TREAT(VALUE(p) AS tp_bombeiro).tempo_servico > 5;

-- Retornar o nome do quartel e seus telefones:
-- Acessando VARRAY
SELECT q.nome AS nome_quartel,
       t.ddd || '-' || t.numero AS telefone
FROM tb_quarteis q,
     TABLE(q.telefones) t;

-- Listar todas as manutenções realizadas em viaturas (NESTED TABLE), incluindo peças trocadas
-- Retornar placa da viatura, tipo de manutenção, data, peça trocada e obs:
-- Acessando NESTED TABLE
SELECT v.placa AS placa_viatura,
       m.tipo AS tipo_manutencao,
       m.data_manutencao,
       p.peca AS peca_trocada,
       m.observacoes
FROM tb_viaturas v,
     TABLE(v.historico_manutencao) m,
     TABLE(m.pecas_trocadas) p;
     
-- Retornar dados das vítimas: nome da vítima, idade, grau de risco e observações:
SELECT p.nome AS nome_vitima,
       TRUNC(MONTHS_BETWEEN(SYSDATE, p.data_nascimento)/12) AS idade,
       TREAT(VALUE(p) AS tp_vitima).grau_risco AS grau_risco,
       TREAT(VALUE(p) AS tp_vitima).observacoes AS observacoes
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_vitima);

-- Retornar todas as viaturas, tipo, estado, nome do quartel e cidade:
SELECT v.placa,
       v.tipo,
       v.estado,
       DEREF(v.quartel_ref).nome AS nome_quartel,
       DEREF(v.quartel_ref).endereco.cidade AS cidade_quartel
FROM tb_viaturas v;

-- Contar número de ocorrências por cidade:
SELECT o.endereco_ocorrencia.cidade AS cidade,
       COUNT(*) AS total_ocorrencias
FROM tb_ocorrencias o
GROUP BY o.endereco_ocorrencia.cidade;

-- Listar viaturas que estão em manutenção e o nome do quartel:
SELECT v.placa,
       v.tipo,
       v.estado,
       DEREF(v.quartel_ref).nome AS nome_quartel
FROM tb_viaturas v
WHERE v.estado = 'Em Manutencao';

-- Listar todas viaturas e a qnt de manutenções realizadas:
SELECT v.placa,
       v.tipo,
       (SELECT COUNT(*) FROM TABLE(v.historico_manutencao)) AS qtd_manutencoes
FROM tb_viaturas v;

-- Listar todas as ocorrências com nome do bombeiro, nome da vítima e placa da viatura:
SELECT o.protocolo,
       DEREF(o.bombeiros_atendimento).nome AS nome_bombeiro,
       DEREF(o.vitimas_atendidas).nome AS nome_vitima,
       DEREF(o.viaturas_usadas).placa AS placa_viatura
FROM tb_ocorrencias o;

-- Listar bombeiros com mais de 10 anos de serviço e o quartel onde atuam:
SELECT p.nome AS nome_bombeiro,
       TREAT(VALUE(p) AS tp_bombeiro).tempo_servico AS anos_servico,
       DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).nome AS nome_quartel
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro)
  AND TREAT(VALUE(p) AS tp_bombeiro).tempo_servico > 10;

-- Listar todos os quarteis e a qnt de bombeiros em cada um:
SELECT DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).nome AS nome_quartel,
       COUNT(*) AS qtd_bombeiros
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro)
GROUP BY DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).nome;


---------------FUNÇÕES E PROCEDURES----------------
-- Como são muito similares, em caso onde tem a mesma consulta para bombeiro e vítima, a consulta
-- da vítima foi omitida.

-- exibir_info()
SELECT TREAT(VALUE(p) AS tp_bombeiro).exibir_info() AS info_bombeiro
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro);

-- get_idade()
SELECT p.nome AS nome_bombeiro,
       TREAT(VALUE(p) AS tp_bombeiro).get_idade() AS idade
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro);

-- get_cpf() 
SELECT p.nome AS nome_bombeiro, 
        TREAT(VALUE(p) AS tp_bombeiro).get_cpf() AS cpf_bombeiro
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro);

-- comparar_data()
DECLARE
    o1 tp_ocorrencia;
    o2 tp_ocorrencia;
    resultado INTEGER;
BEGIN
    SELECT VALUE(o) INTO o1 FROM tb_ocorrencias o WHERE o.protocolo = 1;
    SELECT VALUE(o) INTO o2 FROM tb_ocorrencias o WHERE o.protocolo = 2;

    resultado := o1.comparar_data(o2);
    DBMS_OUTPUT.PUT_LINE('Resultado de comparação: ' || resultado);
END;
/

-- is_operacional()
SELECT v.placa, 
       v.is_operacional() AS operacional 
FROM tb_viaturas v;

-- promover()
-- Exemplo de promoção de bombeiro específico para Tenente.
DECLARE
    b tp_bombeiro;
BEGIN
    -- Busca o bombeiro
    SELECT TREAT(VALUE(p) AS tp_bombeiro)
    INTO b
    FROM tb_pessoas p
    WHERE p.nome = 'Ana Silva';

    -- Promove o bombeiro
    b.promover('Tenente');

    -- Lembrar de atualiza o registro na tabela
    UPDATE tb_pessoas p
    SET VALUE(p) = b
    WHERE p.nome = 'Ana Silva';

    DBMS_OUTPUT.PUT_LINE('Novo posto: ' || b.posto);
END;
/