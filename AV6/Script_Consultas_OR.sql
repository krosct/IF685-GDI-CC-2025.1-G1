-- SCRIPT PARA CONSULTAS OR

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

-- Retornar o nome do quartel associado a cada bombeiro:
SELECT p.nome AS nome_bombeiro, 
    DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).cnpj AS cnpj_quartel, 
    DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).nome AS nome_quartel, 
    DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).endereco AS endereco_quartel
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro);