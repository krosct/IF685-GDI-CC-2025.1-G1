-- SCRIPT PARA CONSULTAS OR

--  Selecionar referências dos bombeiros e seus respectivos quartéis
--  Utiliza a função DEREF para acessar os atributos do objeto referenciado
SELECT p.nome AS nome_bombeiro, DEREF(TREAT(VALUE(p) AS tp_bombeiro).quartel_ref).nome AS nome_quartel
FROM tb_pessoas p
WHERE VALUE(p) IS OF (tp_bombeiro)